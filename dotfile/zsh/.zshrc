export LANG=ja_JP.utf8
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:CLASSPATH
export DVIPDFMINPUTS=.:"$HOME"/.fonts:
export PAGER=lv
export JLESSCHARSET=japanese
export FIGNORE='~:.aux:.o'
export EDITOR=/usr/bin/jed
export SED=sed
export PERL_BADLANG=0

# ファイル作成マスク
umask 002

# cdのサーチパス
cdpath=( ~ )

# プロンプトのカラー表示を有効
autoload -U colors
colors

# デフォルトの補完機能を有効
autoload -U compinit
compinit

# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補
zstyle ':completion:*:cd:*' tag-order local-directories path-directories

# 補完時に大小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補をカーソルで選択する
# zstyle ':completion:*:default' menu select=1

# 色をつける
alias ls="ls -F --color"
export LS_COLORS="no=00:fi=00:di=01;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:";

# 補完候補にも色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# コアファイルを吐かないようにする
limit   coredumpsize    0

# ヒストリサーチのキーバインド
#bindkey '^P' history-beginning-search-backward
#bindkey '^N' history-beginning-search-forward

# プロンプトの設定
unsetopt promptcr # 改行のない出力をプロンプトで上書きするのを防ぐ
setopt PROMPT_SUBST  # ESCエスケープを有効にする
PROMPT='[%n@]%(!.#.$)'
RPROMPT='[%(5~,%-2~/.../%2~,%~)%#]'

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
#alias emacs=/usr/local/emacs/bin/emacs

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

# dump用のpモジュールをつかう
#export PERL5OPT=-MP

#cd -1とかできる
#setopt autopushd

stty -ixon
