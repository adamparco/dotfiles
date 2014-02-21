# .bashrc
#_______________________________________________________________________________________________________
#               Do this stuff first, as it sets up default, replace defaults further down
#_______________________________________________________________________________________________________
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
##### SVDEV BEGIN #####
if [ $(uname) = "Linux" ]; then
    _svdev_view=svdev_view
    export SVDEV="/view/$_svdev_view/vobs/utils/svdev"
elif [ $(uname) = "FreeBSD" ]; then
    _svdev_view=test_main
    export SVDEV="/m/$_svdev_view/utils/svdev"
else
    _svdev_view=svdev_view
    export SVDEV="/m/$_svdev_view/utils/svdev"
fi

if [ -f "${SVDEV}/start.rc.conf" ]; then
    source "${SVDEV}/start.rc.conf"
else
    net start albd >/dev/null 2>&1
    cleartool startview "$_svdev_view" >/dev/null 2>&1
    cleartool mount /vobs/utils >/dev/null 2>&1
    cleartool mount \\utils >/dev/null 2>&1
    if [ -f "${SVDEV}/start.rc.conf" ]; then
        source "${SVDEV}/start.rc.conf"
    fi
fi
##### SVDEV END #####
# Below line added by Sandvine logon script
if [[ -f /etc/profile.d/sandvine.rc ]]; then . /etc/profile.d/sandvine.rc; fi
#_______________________________________________________________________________________________________

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ `uname` = "SVOS" ] ; then
	if [ $TERM = "screen-256color" ] ; then
		export TERM=screen
	fi
    sudo ln -sfn /home/aparco/.vimrc /root/.vimrc &>/dev/null
    sudo ln -sfn /home/aparco/.bashrc /root/.bashrc &>/dev/null
    sudo ln -sfn /home/aparco/.bash_profile /root/.bash_profile &>/dev/null
    sudo ln -sfn /home/aparco/.vim /root/.vim &>/dev/null
    alias gvim='vim'
    alias ls="ls -G"
	export LSCOLORS="ExCxcxdxBxegedabagacad"
elif [ `uname` = "FreeBSD" ] ; then
    alias ls="ls -G"
    export LSCOLORS="ExCxcxdxBxegedabagacad"
elif [ `uname` = "Linux" ] ; then
    alias ls="ls --color"
    #export LS_COLORS="no=00:fi=00:di=00;36:ln=00;35:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;31:*.c md=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lz h=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;3 5:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"
	export LS_COLORS="no=00:fi=00:di=00;94:ln=00;92:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;91:ow=00;94:"
elif [ `uname` = "CYGWIN_NT-6.1-WOW64" ] ; then
    export DISPLAY=localhost:0.0
elif [ `uname` = "Darwin" ] ; then
    alias ls="ls -G"
fi

if [ `uname` != "Linux" ] ; then
    alias tcl='/m/test_main/fwtest/bin/tcl'
else
    alias tcl='/view/aparco_main/vobs/fwtest/bin/tcl'
fi

MYVIMRC=~/.vimrc

PATH=${HOME}/bin:/usr/local/bin:${HOME}/scripts:$PATH

CRST="\[\e[m\]"
CGREY="\[\e[38;5;240m\]"
CGREEN="\[\e[38;5;107m\]"
CBLUE="\[\e[38;5;110m\]"
CRED="\[\e[38;5;52m\]"

export PROMPT_DIRTRIM=4
_DVIEW=""
ccase_view()
{
    # Only linux box I currently go on is SV
    if [ `uname` = "Linux" ] ; then
        export DVIEW=`cat ~/.dview 2>/dev/null`
        _DVIEW=""
        if [[ $PWD == \/view* ]] ; then
            IFS='/' read -a array <<< "$PWD"
            export DVIEW=${array[2]}
            echo $DVIEW > ~/.dview

            num=`echo "$PWD" | grep -o "/" | wc -l`
            #if [ $PROMPT_DIRTRIM -gt 0 -a $num -gt $(($PROMPT_DIRTRIM +1)) ] ; then
                _DVIEW="["$DVIEW"]"
            #fi
        fi
    fi
}

setPS()
{
    export PS1="$CRST$CGREY\u$CRST@$CGREEN\h$CGREY$_DVIEW$CBLUE[\W]$CRST\\$ "
    export PS2="$CRST$CGREY>$CRST "
}

PROMPT_COMMAND='history -a; ccase_view; setPS'

listtmux()
{
    check=0
    case `uname -a` in
        *wtl-lview*)
            check=1
        ;;
    esac

    if [ $check = 1 ] && which tmux >/dev/null 2>&1 && [ -z "$TMUX" ] ; then
        echo
        if [ $(tmux list-sessions 2> /dev/null | wc -l) -gt 0 ]; then
            echo "Active tmux sessions:"
            tmux list-sessions
        else
            echo "No tmux sessions active."
        fi
    fi
}
listtmux


# Turn off Ctrl-S
#stty ixany
#stty ixoff -ixon

set -o emacs
shopt -s checkwinsize

set completion-ignore-case on
set show-all-if-ambiguous on
set show-all-if-unmodified on
#bind '"\t":menu-complete'

if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

#history
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups:erasedups
export HISTFILE=~/.bash_history_eternal
shopt -s histappend
shopt -s cmdhist
shopt -s histverify ## edit a recalled history line before executing
shopt -s histreedit ## reedit a history substitution line if it failed
HISTIGNORE='ls:history:exit'

#alias tmux="TERM=screen-256color tmux -2"
alias tmux="tmux -2"
alias ssh="ssh -Y"
alias l="ls -la"
alias v="vim"
alias g="gvim"
#alias AT="TERM=screen-256color tmux -2 attach"
alias AT="tmux -2 attach"
alias DT="tmux detach"
alias UP="source ~/.bashrc"
alias build64="build -6"
alias make64="CPU=SVOS9_64 make -j 32"
alias cd.="cd .."
alias cd..="cd .."
alias hs="TPC_IN_SAME_WINDOW=1 h"
alias dp="DIFF_TOOL=kdiff3 ccase diff -pre"
alias dps="DIFF_TOOL=diff ccase diff -pre"
alias dh="DIFF_TOOL=kdiff3 ccase diff"
alias dhs="DIFF_TOOL=diff ccase diff"
alias lsspec="ls --color=never /view/aparco_main/vobs/utils/build/cspec"
alias grep="grep --color=auto"

export DIFF_TOOL=kdiff3
export CPU=SVOS9_64

rst()
{
    tcl_main resource tpc-$1 powerCycle
}

view()
{
    echo $DVIEW
}

diffa()
{
    activity=$(cleartool lsact -cact | awk '{print$2}')
    echo "Activity: $activity"
    if [ "$1" == "-s" ]; then
        DIFF_TOOL=diff ccase diff -act $activity
    else
        DIFF_TOOL=kdiff3 ccase diff -act $activity
    fi
}

cdd()
{
    cnt=$1
    while [ $cnt -gt 0 ]
    do
        cd ..
        cnt=$(($cnt - 1))
    done
}