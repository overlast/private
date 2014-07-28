export LANG=ja_JP.UTF-8
export PATH=/usr/local/texlive/2012/bin/x86_64-darwin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:CLASSPATH
export DVIPDFMINPUTS=.:"$HOME"/.fonts:
export PAGER=lv
export JLESSCHARSET=japanese
export FIGNORE='~:.aux:.o'
export EDITOR=/usr/bin/jed
export SED=sed
export PERL_BADLANG=0
export TERM="screen-256color"
alias tmux="tmux -2"
# ファイル作成マスク
umask 002

# cdのサーチパス
cdpath=( ~ )

# プロンプトのカラー表示を有効
autoload -U colors
colors

# デフォルトの補完機能を有効
# cd f/b/b[TAB]でcd foooo/barrr/bazzzと展開される
autoload -U compinit && compinit

# http://news.mynavi.jp/column/zsh/005/index.html
setopt auto_cd
setopt auto_pushd
#setopt correct
setopt list_packed
setopt nolistbeep

# コピペしやすいようにコマンド実行後は右プロンプトを消す。
setopt transient_rprompt

# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補
zstyle ':completion:*:cd:*' tag-order local-directories path-directories

# 補完時に大小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補をカーソルで選択する
# zstyle ':completion:*:default' menu select=1

# 色をつける
#alias ls="ls -F --color"
#export LS_COLORS="no=00:fi=00:di=01;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:";

# 補完候補にも色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# コアファイルを吐かないようにする
limit   coredumpsize    0

# ヒストリサーチのキーバインド
#bindkey '^P' history-beginning-search-backward
#bindkey '^N' history-beginning-search-forward

# プロンプトの設定
unsetopt promptcr # 改行のない出力をプロンプトで上書きするのを防ぐ
setopt prompt_subst  # ESCエスケープを有効にする

# http://d.hatena.ne.jp/uasi/20091017/1255712789
PROMPT='[%n@]%(!.#.$)'
#RPROMPT='[%(5~,%-2~/.../%2~,%~)%#]'

plenv_perl_version() {
    local dir=$PWD

    [[ -n $PLENV_VERSION ]] && { echo $PLENV_VERSION; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.perl-version" ]]; then
            head -n 1 "$dir/.perl-version"
            return
        fi
        dir=$(dirname $dir)
    done

    local plenv_home=$PLENV_HOME
    [[ -z $PLENV_HOME && -n $HOME ]] && plenv_home="$HOME/.plenv"

    if [[ -f "$plenv_home/version" ]]; then
        head -n 1 "$plenv_home/version"
    fi
}

pyenv_python_version() {
    local dir=$PWD

    [[ -n $PYENV_VERSION ]] && { echo $PYENV_VERSION; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.python-version" ]]; then
            head -n 1 "$dir/.python-version"
            return
        fi
        dir=$(dirname $dir)
    done

    local pyenv_home=$PYENV_HOME
    [[ -z $PYENV_HOME && -n $HOME ]] && pyenv_home="$HOME/.pyenv"

    if [[ -f "$pyenv_home/version" ]]; then
        head -n 1 "$pyenv_home/version"
    fi
}

rbenv_ruby_version() {
    local dir=$PWD

    [[ -n $RBENV_VERSION ]] && { echo $RBENV_VERSION; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.ruby-version" ]]; then
            head -n 1 "$dir/.ruby-version"
            return
        fi
        dir=$(dirname $dir)
    done

    local rbenv_home=$RBENV_HOME
    [[ -z $RBENV_HOME && -n $HOME ]] && rbenv_home="$HOME/.rbenv"

    if [[ -f "$rbenv_home/version" ]]; then
        head -n 1 "$rbenv_home/version"
    fi
}

function get_llenv_versions {
    IS_ECHO=0;
    if [ -d ${HOME}/.plenv  ] ; then
        if [ $IS_ECHO -eq 0 ] ; then
            echo -n "("
        fi
        echo -n `plenv_perl_version`
        IS_ECHO=1
    fi
    if [ -d ${HOME}/.pyenv  ] ; then
        if [ $IS_ECHO -eq 0 ] ; then
            echo -n "("
        else
            echo -n "/"
        fi
        IS_ECHO=1
        echo -n `pyenv_python_version`
    fi
    if [ -d ${HOME}/.rbenv  ] ; then
        if [ $IS_ECHO -eq 0 ] ; then
            echo -n "("
        else
            echo -n "/"
        fi
        IS_ECHO=1
        echo -n `rbenv_ruby_version`
    fi
    if [ $IS_ECHO -eq 1 ] ; then
        echo -n ") "
    fi
}

function is_pushed {
    not_pushed="1"
    head=$(git rev-parse --verify -q HEAD 2> /dev/null)
    if [ $? -eq 0 ]; then # success to get hash value of HEAD ?
        # let's get array of remote hash values
        remotes=($(git rev-parse --remotes 2> /dev/null))
        if [ "$remotes[*]" ]; then # success to get hash value of remote ?
            for x in ${remotes[@]}; do # let's compare head hash value and remote hash value
                if [ "$head" = "$x" ]; then # already pushed ?
                    not_pushed=""
                    break
                fi
            done
        else # remote is not there
            not_pushed=""
        fi
    else # HEAD is not there (maybe init)
        not_pushed=""
    fi
    echo "$not_pushed"
}

function rprompt-git-current-branch-status {
    local name st color
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
    if [[ -z $name ]]; then
        return
    fi

    st=$(perl -e 'eval { local $SIG{ALRM} = sub {die}; alarm(1); system("git status -s"); }; if ($@) { print "timeout\n"; }')
    if [ $? -eq 0 ]; then
        if [[ -n `echo "$st" | grep "timeout" `  ]]; then
            color=${fg[white]}
        elif [[ $st = '' ]]; then
            color=${fg[green]}
        elif [[ -n `echo "$st" | perl -e '@a; while($i=<STDIN>) { if ($i =~ m|^[ U]{2} (.+)|) { $t = $1; unless ($t =~ m|[.]{1,}/{1}|) { print $t."\n"; }}}' ` ]]; then
            color=${fg_bold[magenda]}
        elif [[ -n `echo "$st" | perl -e '@a; while($i=<STDIN>) { if ($i =~ m|^[ M]{1}M (.+)|) { $t = $1; unless ($t =~ m|[.]{1,}/{1}|) { print $t."\n"; }}}' ` ]]; then
            color=${fg_bold[red]}
        elif [[ -n `echo "$st" | perl -e '@a; while($i=<STDIN>) { if ($i =~ m|^M  (.+)|) { $t = $1; unless ($t =~ m|[.]{1,}/{1}|) { print $t."\n"; }}}' ` ]]; then
            color=${fg[yellow]}
        elif [[ -n `echo "$st" | perl -e '@a; while($i=<STDIN>) { if ($i =~ m|^[ ADRC]{2} (.+)|) { $t = $1; unless ($t =~ m|[.]{1,}/{1}|) { print $t."\n"; }}}' ` ]]; then
            color=${fg[yellow]}
        elif [[ `is_pushed` = "1" ]]; then
            color=${fg[blue]}
        elif [[ -n `echo "$st" | perl -e '@a; while($i=<STDIN>) { if ($i =~ m|^[ \?]{2} (.+)|) { $t = $1; unless ($t =~ m|[.]{1,}/{1}|) { print $t."\n"; }}}' ` ]]; then
            color=${fg[cyan]}
        else
            color=${fg[green]}
        fi
    fi
    # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
    # これをしないと右プロンプトの位置がずれる
    echo "%{$color%}$name%{$reset_color%} "
}
RPROMPT='[`get_llenv_versions``rprompt-git-current-branch-status`%(5~,%-2~/.../%2~,%~)%#]'

#コマンドが上手く表示されないときは
#Emacsの場合はctrl+qしてescを押すと「」と出るので
#この文字列「」を全部打ち直すとうまくいく
#wd () { ... echo '^[[32m'`pwd`'^[[m' && ls }
if [ "$TERM" = "screen" ]; then
    chpwd () { echo -n "_`dirs`\\" && echo '[32m'`pwd`'[m' && ls  }
    preexec() {
	# see [zsh-workers:13180]
	# http://www.zsh.org/mla/workers/2000/msg03993.html
	emulate -L zsh
	local -a cmd; cmd=(${(z)2})
	case $cmd[1] in
	    fg)
		if (( $#cmd == 1 )); then
		    cmd=(builtin jobs -l %+)
		else
		    cmd=(builtin jobs -l $cmd[2])
		fi
		;;
	    %*)
		cmd=(builtin jobs -l $cmd[1])
		;;
	    cd)
		if (( $#cmd == 2)); then
		    cmd[1]=$cmd[2]
		    fi
		;&
	    *)
                echo -n "k$cmd[1]:t\\"
		return
		;;
	    esac

	local -A jt; jt=(${(kv)jobtexts})

	$cmd >>(read num rest
	    cmd=(${(z)${(e):-\$jt$num}})
	    echo -n "k$cmd[1]:t\\") 2>/dev/null
	}
    chpwd
fi

# ベルを鳴らさない。
setopt no_beep

# 日本語ファイル名がちゃんと表示されるようにする
setopt print_eight_bit

#Ctrl+D をキーするとログアウトしてしまうが、これを防ぐなら
setopt IGNORE_EOF

#履歴をファイルに保存(satoruさん)
HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する

# 先頭がスペースならヒストリーに追加しない。
setopt hist_ignore_space

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
#setopt hist_ignore_all_dups

# 直前と同じコマンドラインはヒストリに追加しない
#setopt hist_ignore_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

#プロセスで履歴を共有
setopt share_history

# ctrl-oでヒストリー(by gorouたん)
#$HOMEにtmpが無いとだめ
# dabbrev
HARDCOPYFILE=$HOME/tmp/screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete () {
        local reply lines=80 # 80行分
        screen -X eval "hardcopy -h $HARDCOPYFILE"
        reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
        compadd - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
bindkey '^o^_' reverse-menu-complete

#全プロセスから引数の文字列を含むものを grep する
function psg() {
    ps ax | head -n 1 # ラベルを表示
    ps ax | grep $* | grep -v "ps -auxww" | grep -v grep # grep プロセスを除外
}

# cdしたらls
function chpwd() { ls -F }

#引数の検索ワードで google 検索。日本語可。
function google() {
  local str opt
  if [ $# != 0 ]; then # 引数が存在すれば
    for i in $*; do
      str="$str+$i"
    done
    str=`echo $str | sed 's/^\+//'` #先頭の「+」を削除
    opt='search?num=50&hl=ja&ie=euc-jp&oe=euc-jp&lr=lang_ja'
    opt="${opt}&q=${str}"
  fi
  w3m http://www.google.co.jp/$opt #引数がなければ $opt は空になる
  # mozilla -remote openURL\(http::/www.google.co.jp/$opt\) # 未テスト
}
alias ggl=google
alias emacs="TERM=screen-256color emacs -nw"
alias javac='javac -J-Dfile.encoding=UTF-8'
alias java='java -Dfile.encoding=UTF-8'

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

alias h='hostname'

alias diff='diff -up'

alias cd+='pushd'
alias cd-='popd'
alias cd--='popd 2'
alias cd---='popd 3'
alias pd='pushd'
alias bd='popd'
alias bd2='popd -2'
alias bd3='popd -3'

alias screen='screen -U'

# http://qiita.com/items/7916037b1384d253b457
# 今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..

# dump用のpモジュールをつかう
#export PERL5OPT=-MP

#cd -1とかできる
#setopt autopushd

# able to use C-s and C-q
stty -ixon

# plenv
# how to install : cd; git clone git://github.com/tokuhirom/plenv.git ~/.plenv
if [ -d ${HOME}/.plenv  ] ; then
  export PATH="${HOME}/.plenv/bin:${PATH}"
  eval "$(plenv init -)" # == 'export PATH="${HOME}/.plenv/shims:${PATH}"'
fi

##perlbrew
#if [ -f ${HOME}/perl5/perlbrew/etc/bashrc ] ; then
#    source ${HOME}/perl5/perlbrew/etc/bashrc
#fi

# pyenv
# how to install : cd; git clone git://github.com/yyuu/pyenv.git .pyenv
if [ -d ${HOME}/.pyenv  ] ; then
  export PATH="${HOME}/.pyenv/bin:${PATH}"
  eval "$(pyenv init - zsh)" # == 'export PATH="${HOME}/.pyenv/shims:${PATH}"'
fi

# rbenv
# how to install : cd; git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
if [ -d ${HOME}/.rbenv  ] ; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init - zsh)" # == 'export PATH="${HOME}/.rbenv/shims:${PATH}"'
fi

# ocamlbrew
# how to install : curl -kL https://raw.github.com/hcarty/ocamlbrew/master/ocamlbrew-install | env OCAMLBREW_FLAGS="-r" bash
# OPAM configuration
if [ -d ${HOME}/ocamlbrew ] ; then
  export PATH=${HOME}/ocamlbrew/ocaml-4.00.1/bin:$PATH
  export OPAMROOT=${HOME}/ocamlbrew/ocaml-4.00.1/.opam
  eval `opam config env`
fi

# scalaenv
# how to install : cd; git clone git://github.com/mazgi/scalaenv.git ~/.scalaenv
if [ -d ${HOME}/.scalaenv  ] ; then
  export PATH="${HOME}/.scalaenv/bin:${PATH}"
  eval "$(scalaenv init - zsh)" # == 'export PATH="${HOME}/.scalaenv/shims:${PATH}"'
fi

# sbtenv
# how to install : cd; git clone git://github.com/mazgi/sbtenv.git ~/.sbtenv
if [ -d ${HOME}/.sbtenv  ] ; then
  export PATH="${HOME}/.sbtenv/bin:${PATH}"
  eval "$(sbtenv init - zsh)" # == 'export PATH="${HOME}/.sbtenv/shims:${PATH}"'
fi

# playenv
# how to install : cd; git clone git://github.com/mazgi/playenv.git ~/.playenv
if [ -d ${HOME}/.playenv  ] ; then
  export PATH="${HOME}/.playenv/bin:${PATH}"
  eval "$(playenv init - zsh)" # == 'export PATH="${HOME}/.playenv/shims:${PATH}"'
fi

# gvm
# how to install :curl -s get.gvmtool.net | bash
#if [ -d ${HOME}/.gvm  ] ; then
 # export PATH="${HOME}/.gvm/bin:${PATH}"
#fi


# Haskell configuration
if [ -d ${HOME}/.cabal  ] ; then
    export PATH=$PATH:$HOME/.cabal/bin
fi


function setjdk {
    pathtojava=$(readlink -e /usr/bin/javac)
    export JAVA_HOME=${pathtojava%/*/*}
}

use-java () {
    MYOS="$(uname)" # get os name
    case $MYOS in
        Linux) setjdk ;;
        Darwin) export JAVA_HOME=`/usr/libexec/java_home -v 1.$1` ;;
        *) ;;
    esac
}
use-java

# keep SSH_AUTH_SOCK 

# Find a usable agent
function ssh-reagent () {
    ls /tmp/|grep ssh-
    if [ $? -eq 0  ]; then
	export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent\* -printf ‘'%T@ %p\n' | sort -k 1nr | sed 's/^[^ ]* //' | head -n 1)
	if $(ssh-add -l > /dev/null) ; then
	    echo Found working SSH Agent:
	    ssh-add -l
	    return
	else
	    echo "Cannot find ssh agent – maybe you should reconnect and forward it?"
	    export SSH_AUTH_SOCK=""
	fi
    else 
	echo "Cannot find ssh agent – maybe you should reconnect and forward it"
	export SSH_AUTH_SOCK=""
    fi
}

function exec-ssh-agent () {
  eval `ssh-agent` > ~/.ssh-agent.tmp
  MY_SSH_AGENT_PID=`cat ~/.ssh-agent.tmp|cut -d" " -f3`
  rm -f ~/.ssh-agent.tmp
  if [ -s ~/.ssh/id_rsa ]; then 
      ssh-add ~/.ssh/id_rsa
  fi
  if [ -s ~/.ssh/id_rsa.team-1 ]; then 
      ssh-add ~/.ssh/id_rsa.team-1
  fi
}

agent="$HOME/tmp/.ssh-agent-`hostname`"
ENV_SSH_AUTH_SOCK=`env|grep "SSH_AUTH_SOCK"`

if [ "$ENV_SSH_AUTH_SOCK" != "" ];then
    if [ "$SSH_AUTH_SOCK" != "" ];then
	if [ ! -S "$SSH_AUTH_SOCK" ]; then
	    export SSH_AUTH_SOCK=""
	    if [ -s $agent ]; then
		rm $agent
	    fi
	fi
    fi
fi

if [ "$SSH_AUTH_SOCK" != "" ];then
    if [ "$SSH_AUTH_SOCK" = "SSH_AUTH_SOCK=" ];then
	ssh-reagent
	if [ -s $agent ]; then
	    rm $agent
	fi
    fi
else
    ssh-reagent
    if [ -s $agent ]; then
	rm $agent
    fi
fi

if [ "$SSH_AUTH_SOCK" != "" ];then
    if [ "$SSH_AUTH_SOCK" = "SSH_AUTH_SOCK=" ];then
	exec-ssh-agent
	if [ -s $agent ]; then
	    rm $agent
	fi
    fi
else
    exec-ssh-agent
    if [ -s $agent ]; then
	rm $agent
    fi
fi

if [ -S "$agent" ]; then
    export SSH_AUTH_SOCK=$agent
elif [ ! -S "$SSH_AUTH_SOCK" ]; then
    #export SSH_AUTH_SOCK=$agent
    echo "no ssh-agent"
elif [ ! -L "$SSH_AUTH_SOCK" ]; then
    ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
fi


