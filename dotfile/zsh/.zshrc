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
function rprompt-git-current-branch-status {
    local name st color
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
    if [[ -z $name ]]; then
        return
    fi
    st=`perl -e 'alarm(1); system("git status");'`
    if [[ $st = '' ]]; then
        color=${fg[magenta]}
    elif [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=${fg[green]}
    elif [[ -n `echo "$st" | perl -ne '@a; while($i=<STDIN>) {push @a, $i;}; $t = join "", @a; if ($t =~ m|^# Change.+?# *\n# *(.+?)\n# *\n# *|ms) { $t = $1; unless ($t =~ m|[.]{1,}/{1}|) { print $t; }}' | grep "/"` ]]; then # Changed but not updated|Changes not staged for commit
        color=${fg_bold[red]}
    elif [[ -n `echo "$st" | grep "Your branch is ahead of"` ]]; then
        color=${fg[cyan]}
    elif [[ -n `echo "$st" | grep "Changes to be committed"` ]]; then
        color=${fg[blue]}
    elif [[ -n `echo "$st" | perl -ne '@a; while($i=<STDIN>) {push @a, $i;}; $t = join "", @a; if ($t =~ m|^# Untracked files.+?to include in what will be committed.+?\n#(.+)#|ms) { $t = $1; @ua = split /\n/, $t; foreach my $u (@ua) { unless ($u =~ m|[.]{1,}/{1}|) { print $u; }}}' | grep "/"` ]]; then
        color=${fg[yellow]}
    else
        color=${fg[green]}
    fi
    # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
    # これをしないと右プロンプトの位置がずれる
    echo "%{$color%}$name%{$reset_color%} "
}
RPROMPT='[`rprompt-git-current-branch-status`%(5~,%-2~/.../%2~,%~)%#]'

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

stty -ixon
export PERLBREW_BASHRC_VERSION=0.46

[[ -z "$PERLBREW_ROOT" ]] && export PERLBREW_ROOT="$HOME/perl5/perlbrew"
[[ -z "$PERLBREW_HOME" ]] && export PERLBREW_HOME="$HOME/.perlbrew"

if [[ ! -n "$PERLBREW_SKIP_INIT" ]]; then
    if [[ -f "$PERLBREW_HOME/init" ]]; then
        . "$PERLBREW_HOME/init"
    fi
fi

__perlbrew_reinit () {
    if [[ ! -d "$PERLBREW_HOME" ]]; then
        mkdir -p "$PERLBREW_HOME"
    fi

    echo '# DO NOT EDIT THIS FILE' >| "$PERLBREW_HOME/init"
    command perlbrew env $1 >> "$PERLBREW_HOME/init"
    . "$PERLBREW_HOME/init"
    __perlbrew_set_path
}

__perlbrew_set_path () {
    [[ -n $(alias perl 2>/dev/null) ]] && unalias perl 2>/dev/null

    export PATH_WITHOUT_PERLBREW="$(perl -e 'print join ":", grep { index($_, $ENV{PERLBREW_HOME}) < 0 } grep { index($_, $ENV{PERLBREW_ROOT}) < 0 } split/:/,$ENV{PATH};')"

    if [[ -z "$PERLBREW_PATH" ]]; then
        export PERLBREW_PATH="$PERLBREW_ROOT/bin"
    fi

    export PATH="$PERLBREW_PATH:$PATH_WITHOUT_PERLBREW"
    export MANPATH_WITHOUT_PERLBREW="$(perl -e 'print join ":", grep { index($_, $ENV{PERLBREW_ROOT}) } split/:/,qx(manpath);')"
    if [ -n "$PERLBREW_MANPATH" ]; then
        export MANPATH="$PERLBREW_MANPATH:$MANPATH_WITHOUT_PERLBREW"
    else
        export MANPATH="$MANPATH_WITHOUT_PERLBREW"
    fi
}
__perlbrew_set_path

perlbrew () {
    local exit_status
    local short_option
    export SHELL

    if [[ $1 == -* ]]; then
        short_option=$1
        shift
    else
        short_option=""
    fi

    case $1 in
        (use)
            if [[ -z "$2" ]] ; then
                if [[ -z "$PERLBREW_PERL" ]] ; then
                    echo "Currently using system perl"
                else
                    echo "Currently using $PERLBREW_PERL"
                fi
            else
                code=$(command perlbrew env $2);
                if [ -z "$code" ]; then
                    exit_status=1
                else
                    OLD_IFS=$IFS
                    IFS="$(echo -e "\n\r")"
                    for line in $code; do
                        eval $line
                    done
                    IFS=$OLD_IFS
                    __perlbrew_set_path
                fi
            fi
            ;;

        (switch)
              if [[ -z "$2" ]] ; then
                  command perlbrew switch
              else
                  perlbrew use $2 && __perlbrew_reinit $2
              fi
              ;;

        (off)
            unset PERLBREW_PERL
            eval `perlbrew env`
            __perlbrew_set_path
            echo "perlbrew is turned off."
            ;;

        (switch-off)
            unset PERLBREW_PERL
            __perlbrew_reinit
            echo "perlbrew is switched off."
            ;;

        (*)
            command perlbrew $short_option "$@"
            exit_status=$?
            ;;
    esac
    hash -r
    return ${exit_status:-0}
}
