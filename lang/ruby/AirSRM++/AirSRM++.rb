#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'hpricot'
require 'open-uri'
require 'rexml/document'
require 'pp'
require 'optparse'
require 'fileutils'

SrcDir     = File.expand_path(__FILE__).sub(/[^\/]+$/,'')
XMLFILE    = "#{SrcDir}/tc.xml"
ConfigFile = "#{SrcDir}/AirSRM++.config"

options = {}

# parse the config file
if File.exist?(ConfigFile)
  open(ConfigFile,'r').each do |ln|
    ln.gsub!(/\s/,'')
    ln.sub!(/#.*$/,'')
    tmp = ln.split(/=/)
    options[tmp[0].intern] = tmp[1] if tmp[0]
  end
end


unless %W[java cc cs].inject(true) {|s,i| s or (options[:language] == i)}
  puts "Language option is wrong. Default language: cc"
  options[:language] = "cc"
end

# template
MAINBODY = open("#{SrcDir}/template/MainTemplate.#{options[:language]}",'r').read
TESTCODE = open("#{SrcDir}/template/TestTemplate.#{options[:language]}",'r').read
YOURCODE = open("#{SrcDir}/template/CodeTemplate.#{options[:language]}",'r').read

class AirSRM

  def initialize options
    @username  = options[:username]
    @password  = options[:password]
    @language  = options[:language]
    @overwrite = options[:force   ]
    @srm       = options[:srm     ].to_i
    @div       = options[:division].to_i
    @level     = options[:level   ].to_i

    @agent = Mechanize.new do |a|
      a.user_agent_alias = 'Mechanize'
    end
    @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#    @agent.agent.http.ssl_version = "SSLv3"
    @agent.agent.user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7'
    @agent.agent.read_timeout = 100

    FileUtils.mkdir_p("#{SrcDir}/problem") unless FileTest.exist?("#{SrcDir}/problem")

    @rd          = getRoundId()
    @problem     = getProblem()
    @pm          = @problem[:id]
    @fnStatement = "#{SrcDir}/problem/SRM#{@srm}_d#{@div}_l#{@level;}_#{@problem[:name]}.html"
    @fnParameter = "#{SrcDir}/problem/SRM#{@srm}_d#{@div}_l#{@level;}_#{@problem[:name]}.systemtest.html"
    @fnMatchEditorials = "#{SrcDir}/problem/SRM#{@srm}_d#{@div}_l#{@level;}_#{@problem[:name]}.matcheditorial.html"
    @fnTestCode  = "#{SrcDir}/problem/SRM#{@srm}_d#{@div}_l#{@level;}_Test#{@problem[:name]}.#{options[:language]}"
    @fnYourCode  = "#{SrcDir}/problem/SRM#{@srm}_d#{@div}_l#{@level;}_#{@problem[:name]}.#{options[:language]}"
  end

  def login
    return if @agent.cookie_jar.jar[".topcoder.com"]
    print "Login to TopCoder.com ... "
    page = @agent.get('https://community.topcoder.com/tc?&module=Login')

    sys_form = page.form("frmLogin")
    sys_form.field_with(:name => 'username').value = @username
    sys_form.field_with(:name => 'password').value = @password

    page = @agent.submit(sys_form)

    unless page.body.index("Forgot") == nil
      puts "Login error"
      exit
    end
    puts "Done."
  end

  def getRoundId

    if File.exist?(XMLFILE) then
      file_mtime = File.mtime("tc.xml")
      file_year = file_mtime.year
      file_month = file_mtime.month
      file_day = file_mtime.day
      now = Time.now
      now_year = now.year
      now_month = now.month
      now_day = now.day
      if ((file_year != now_year) || (file_month != now_month) || (file_day != now_day)) then
        FileUtils.rm(XMLFILE)
      end
    end

    if (not File.exist?(XMLFILE)) or (@overwrite)
      print "Saving a round list ... "
      open(XMLFILE,'w') do |file|
        file.write(@agent.get("http://www.topcoder.com/tc?module=BasicData&c=dd_round_list").body)
      end
      puts "Done."
    end
    roundList = REXML::Document.new(File.open(XMLFILE,'r').read)

    roundList.elements.each("dd_round_list/row") do |i|
      if i.elements["short_name"].text =~ /#{@srm}/
        return i.elements["round_id"].text
      end
    end

    puts "SRM not found."
    exit
  end

  def getProblem
    # https://community.topcoder.com/stat?c=round_overview&er=0&rd=14550
    page = @agent.get("https://community.topcoder.com/stat?c=round_overview&er=0&rd=#{@rd}")
    problemList = page.links.map do |i|
      {:url=>i.uri.to_s,:name=>i.text}
    end.delete_if do |i|
      not (i[:url] =~ /problem_statement/)
    end

    ret = problemList[3*(@div-1)+@level-1]
    ret[:id] = ret[:url].sub(/.*pm=/,'').sub(/&rd.*/,'')
    ret
  end

  def saveStatement

    if File.exist?(@fnStatement) and (not @overwrite)
      puts "The problem statement, #{@fnStatement}, exists."
      return
    end

    login()
    origin = "http://community.topcoder.com/stat?c=problem_statement&pm=#{@pm}&rd=#{@rd}"
    page = @agent.get(origin)
    flag = false
    cnt = ["<html><body>",
           "<p><a href=\"#{origin}\">#{page.body.scan(/<a .*?ProblemDetail.*?>(.*?)<\/a>/).flatten.first}</a> on community.topcoder.com</p>"
    ]
    page.body.split("\n").each do |i|
      if i =~ /BEGIN BODY/
        flag = true
      elsif i =~ /END BODY/
        break
      end
      cnt << i.gsub(/BGCOLOR=".*?"/,'') if flag
    end
    cnt << "</body></html>"

    cnt = cnt.join("\n")
    cnt.gsub!(/<IMG.*?>/,'')
    cnt.gsub!(/BACKGROUND=".*?"/,'')
    cnt.gsub!(/<TD.*?>\s*?<\/TD>/,'')
    cnt.gsub!(/<TD.*?bodyTextBold.*?>.*?<\/TD>/m,'')
    cnt.gsub!(/<TR.*?>\s*?<\/TR>/,'')
    cnt.gsub!(/<TABLE.*?>\s*?<\/TABLE>/,'')
    cnt.gsub!(/^\s*$/,'')
    cnt.gsub!(/\n+/,"\n")


    print "Saving the statement, #{@fnStatement} ... "
    open(@fnStatement,"w") do |file|
      file.write(cnt)
    end
    puts "Done."
  end

  def saveMatchEditorials

    if File.exist?(@fnMatchEditorials) and (not @overwrite)
      puts "The match editorials, #{@fnMatchEditorials}, exists."
      return
    end

    login()
    origin = "http://community.topcoder.com/tc?module=Static&d1=match_editorials&d2=srm#{@srm}"

    if (@srm > 433)
      origin = "http://apps.topcoder.com/wiki/display/tc/SRM+#{@srm}"
    end

    page = @agent.get(origin)
    flag = false
    cnt = ["<html><body>",
           "<p><a href=\"https://www.otinn.com/topcoder/al/summary.php?rid=#{@rd}\">Summary of of SRM#{@srm}</a> on www.otinn.com</p>",
           "<p><a href=\"#{origin}\">Match Editorial of SRM#{@srm}</a> on community.topcoder.com</p>"
    ]
    page.body.split("\n").each do |i|
      if i =~ /TopCoder Competitions/
        flag = true
      elsif i =~ /<a name="comments">Comments/
        break
      end
      cnt << i.gsub(/BGCOLOR=".*?"/,'') if flag
    end
    cnt << "</body></html>"

    cnt = cnt.join("\n")
    cnt.gsub!(/<IMG.*?>/,'')
    cnt.gsub!(/BACKGROUND=".*?"/,'')
    cnt.gsub!(/<TD.*?>\s*?<\/TD>/,'')
    cnt.gsub!(/<TD.*?bodyTextBold.*?>.*?<\/TD>/m,'')
    cnt.gsub!(/<TR.*?>\s*?<\/TR>/,'')
    cnt.gsub!(/<TABLE.*?>\s*?<\/TABLE>/,'')
    cnt.gsub!(/^\s*$/,'')
    cnt.gsub!(/\n+/,"\n")


    print "Saving the match editorials, #{@fnMatchEditorials} ... "
    open(@fnMatchEditorials,"w") do |file|
      file.write(cnt)
    end
    puts "Done."
  end

  def saveSystemTestParam
    if File.exist?(@fnParameter) and (not @overwrite)
      puts "The test cases, #{@fnParameter}, exist."
      return
    end

    login()
    # http://community.topcoder.com/tc?module=ProblemDetail&rd=14550&pm=11665
    page = @agent.get("http://community.topcoder.com/tc?module=ProblemDetail&rd=#{@rd}&pm=#{@pm}")

    solutions = page.links.map {|i| i.uri.to_s}.delete_if {|i| not (i =~ /solution&cr=\d/)}
    if solutions.length == 0
      puts "Fatal Error (no solution)"
      exit
    end
    page = @agent.get(solutions.first)

    flag = false
    cnt = ["<html><body>",
           "<p><a href=\"http://community.topcoder.com/stat?c=round_stats_sorted&rd=#{@rd}&dn=#{@div}&sq=Round_Statistics_Data&sc=10&sd=desc\">Match Result</a> on community.topcoder.com</p>",
    "<p>Parameters and expected results</p>"]
    page.body.split("\n").each do |i|
      if i =~ /- System/
        flag = true
      elsif i =~ /End System/
        break
      end
      cnt << i if flag
    end
    cnt << "</body></html>"


    cnt = cnt.join("\n")
    cnt.gsub!(/BGCOLOR=".*?"/,'')
    cnt.gsub!(/BACKGROUND=".*?"/,'')
    cnt.gsub!(/<IMG.*?>/,'')
    cnt.gsub!(/<TD.*?>\s*?<\/TD>/,'')
    cnt.gsub!(/<TD.*?>Passed<\/TD>/,'')
    cnt.gsub!(/<TD.*?middle.*?>.*?<\/TD>/m,'')
    cnt.gsub!(/<TD.*?statTextBig.*?>.*?<\/TD>/m,'')
    cnt.gsub!(/<TR.*?>\s*?<\/TR>/,'')
    cnt.gsub!(/^\s*$/,'')
    cnt.gsub!(/\n+/,"\n")
    cnt.sub!(/BORDER="0"/,'BORDER="1"')


    print "Saving test cases, #{@fnParameter} ... "
    open(@fnParameter,"w") do |file|
      file.write(cnt)
    end
    puts "Done."
  end

  def getDefinition fn
    cnt = Hpricot(open(fn,"r").read)
    arr = (cnt/:tr).map {|i| (i/:td).map {|j| j.inner_html}}.delete_if {|i|
      %W[Returns Parameters Method Class].inject(true) {|s,j| s = s and (i[0] != (j+":"))}
    }
    ret = {}
    arr.each do |i|
      ret[:"#{i[0].sub(/:/,'').downcase}"] = i[1].gsub(/\s+/,'')
    end

    unless @language == 'java'
      [:parameters, :returns].each do |key|
        #ret[key].gsub!(/String\[\]/, @language == 'cs' ? 'string[]' : 'vector<string>')
        ret[key].gsub!(/String/, 'string')
        ret[key].gsub!(/(\w+)\[\]/, "vector<\\1>") if @language == 'cc'
      end
    end
    ret
  end


  def genMainCode n,definition, parameter
    ret = String.new(MAINBODY)
    ret.sub!(/\$NUMBER\$/,n.to_s)
    ret.sub!(/\$CLASSNAME\$/,definition[:class])
    ret.sub!(/\$METHODNAME\$/,definition[:method])
    #ret.sub!(/\$PARAMETER\$/,parText)
    #ret.sub!(/\$ANSWER\$/,parameter[1]) # fail when the parameter contains a backslash.

    if @language == 'cc'
      methodargs = ["hogeA"]
      definition[:parameters].count(',').times do |i|
        methodargs << methodargs[i].next
      end
      ret.sub!(/\$PARAMETER\$/,methodargs.join(","))
      ret.sub!(/\$ANSWER\$/,"returnVal")

      # type, name, value
      params = [definition[:parameters].split(/,/),definition[:returns]].flatten.zip(
        [methodargs,"returnVal"].flatten,
        [parameter[0].split(/,\n/),parameter[1]].flatten
      )


      strPrepare = params.map do |type,name,value|
        i = ""
        if type =~ /vector/
          i += "#{type.scan(/<(.*)>/).flatten.first} #{name}Array[] = #{value};\n"
          i += "#{type} #{name}( #{name}Array, #{name}Array + ARRSIZE(#{name}Array) );\n"
        else
          i += "#{type} #{name} = #{value};\n"
        end
        i
      end.join

      ret.sub!(/\$PREPAREDEF\$/,strPrepare)
    else
      parText = definition[:parameters].split(",").zip(parameter[0].split("\n")).map do |i,j|
        tmp = j
        if i =~ /\[\]/
          tmp = "new #{i}#{j}"
        elsif i =~ /char/ and (not j =~ /^'/)
          tmp = "'" + j + "'"
        elsif i =~ /String/ and (not j =~ /^"/)
          tmp = '"' + j + '"'
        end
        tmp
      end.join

      ret = ret.split(/\$PARAMETER\$/).join(parText)


      answer = parameter[1]
      if definition[:returns] =~ /\[\]/
        answer = "new #{definition[:returns]}#{parameter[1]}"
      end
      ret = ret.split(/\$ANSWER\$/).join(answer)
    end

    ret.gsub!(/",/,"\",\n")

    ret
  end

  def genYourCode definition
    cnt = open(@fnStatement,"r").read
    cnt.gsub!(/<pre>/,'')
    cnt.gsub!(/<\/pre>/,'')
    cnt.gsub!(/&quot;/,"\"")
    cnt = Hpricot(cnt)/:table/:tr/:td/:table/:tr/:td/:table/:tr/:td/:table/:tr/:td

    arr = (cnt/:table/:tr/:td).map {|i| i.inner_html.gsub(/\n/,'')}
    params = arr.delete_if {|i| i=~/[\.!]\s*$/ || i=~/<.*>/ || i=="" || i=~/^[A-Z]/} # reject sentences.

    arr = cnt.map {|i| i.inner_html}
    returns = arr.delete_if {|i| not i=~/Returns: /}.map{|i| i.sub(/Returns: /,'')}
    #returns = returns.map {|i| "new #{definition[:returns]}#{i}"} if definition[:returns] =~ /\[\]/

    arr = cnt.map {|i| i.inner_html}
    methodparms = arr[arr.index("Method signature:")+1].scan(/\((.*?)\)/).flatten.first
    methodparms.gsub!(/(\w+)\[\]/, "vector<\\1>") if @language == 'cc'

    np = params.length / returns.length
    main = ''
    returns.length.times do |i|
      main += genMainCode(i,definition,[params[np*i..np*i+np-1].join(",\n"),returns[i]])
    end

    ret = String.new(YOURCODE)
    ret = ret.split(/\$MAINBODY\$/).join(main)
    ret.gsub!(/\$CLASSNAME\$/,definition[:class])
    ret.gsub!(/\$RC\$/,definition[:returns])
    ret.gsub!(/\$METHODNAME\$/,definition[:method])
    ret.gsub!(/\$METHODPARMS\$/,methodparms)
    ret.gsub!(/\$BEGINCUT\$/,'// BEGIN CUT HERE')
    ret.gsub!(/\$ENDCUT\$/,'// END CUT HERE')
    ret.gsub!(/\$PROBLEMDESC\$/,'')
    ret.gsub!(/\$WRITERCODE\$/,'')




    ret
  end

  def saveYourCode
    if File.exist?(@fnYourCode) # not depend on "force" option.
      puts "#{@fnYourCode} exists."
      return
    end

    df = getDefinition(@fnStatement)
    print "Saving #{@fnYourCode} ... "
    open(@fnYourCode,"w") do |file|
      file.write(genYourCode(df))
    end
    puts "Done."
  end

  def genTestCode definition,parameters
    main = ''
    parameters.length.times do |i|
      main += genMainCode(i,definition,parameters[i])
    end

    ret = String.new(TESTCODE)
    ret.sub!(/\$CLASSNAME\$/, "SRM#{@srm}_d#{@div}_l#{@level;}_#{@problem[:name]}")
    ret = ret.split(/\$MAINBODY\$/).join(main)
    ret
  end


  def saveSystemTest
    def getParameters fn
      (Hpricot(open(fn,'r').read)/:tr).map {|i| (i/:td).map {|i| i.inner_html.gsub(/\\/,"\\\\\\")}}
    end
    if File.exist?(@fnTestCode) and (not @overwrite)
      puts "Test code, #{@fnTestCode}, exists."
      return
    end

    saveStatement
    df = getDefinition(@fnStatement)

    saveSystemTestParam
    pa = getParameters(@fnParameter)

    print "Saving #{@fnTestCode} ... "
    open(@fnTestCode,"w") do |file|
      file.write(genTestCode(df,pa))
    end
    puts "Done."
  end


end


options[:systemtest] = false
options[:all] = false
options[:force] = false
optparse = OptionParser.new do |opts|
  opts.on('--systemtest') do
    options[:systemtest] = true
  end
  opts.on('--all') do
    options[:all] = true
  end
  opts.on('-f','--force') do
    options[:force] = true
  end
  opts.on('--srm=VAL') do |v|
    options[:srm] = v
  end
  opts.on('--div=VAL','--division=VAL') do |v|
    if v == "1" or v == "2"
      options[:division] = v
    else
      puts "--division=[1-2]"
      exit
    end
  end

  opts.on('--lv=VAL','--level=VAL') do |v|
    if 1 <= v.to_i and v.to_i <= 3
      options[:level] = v
    else
      puts "--level=[1-3]"
      exit
    end
  end

end
optparse.parse!

# get necessary parameters from STDIN.
%W[username password srm division level].each do |s|
  unless options[s.intern]
    begin
      print "#{s}: "
    end while (options[s.intern] = STDIN.gets.chomp) == ""
  end
end

if (options[:all])
  tmp = AirSRM.new(options)
  tmp.saveStatement
  tmp.saveMatchEditorials
  tmp.saveYourCode
  tmp.saveSystemTest
elsif (options[:systemtest])
  AirSRM.new(options).saveSystemTest
else
  tmp = AirSRM.new(options)
  tmp.saveStatement
  tmp.saveYourCode
end
