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

#SVDEV sets this and makes this terrible
#unset VIMINIT

# Turn off Ctrl-S flow control binding, and allow for emacs Ctrl-s forward search
stty ixany
stty ixoff -ixon

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
#shopt -s histreedit ## reedit a history substitution line if it failed
HISTIGNORE='ls:history:exit'

# SVOS Build Related
export USE_NONRECURSIVE_MAKE=1
export CPU=SVOS9_64
export TEST_FORCE_RUN=1
alias b64="build -6"
alias b32="build -5"
alias m="make -j 128"
alias ma="ALLDEPS=1 make -j 128"
alias m32="CPU=SVOS9 make -j 128"
alias ma32="ALLDEPS=1 CPU=SVOS9 make -j 128"

alias ls_show_reservations="tcl reserve ls -resource"
alias ls_show_reservation="tcl reserve show"

alias v="vim"
alias g="gvim"
[ -f /usr/local/fw-tools/Linux/bin/vim ] && alias vim=/usr/local/fw-tools/Linux/bin/vim 
[ -f /usr/local/fw-tools/Linux/bin/gvim ] && alias gvim=/usr/local/fw-tools/Linux/bin/gvim 
[ -f /usr/local/fw-tools/Linux/bin/vim ] && alias v=/usr/local/fw-tools/Linux/bin/vim 
[ -f /usr/local/fw-tools/Linux/bin/gvim ] && alias g=/usr/local/fw-tools/Linux/bin/gvim 

#alias tmux="TERM=screen-256color tmux -2"
alias tmux="tmux -2"
alias ssh="ssh -Y"
alias l="ls -la --color=auto"
#alias AT="TERM=screen-256color tmux -2 attach"
alias AT="tmux -2 attach"
alias DT="tmux detach"
alias UP="source ~/.bashrc"
alias cd.="cd .."
alias cd..="cd .."
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias hs="TPC_IN_SAME_WINDOW=1 h"
alias dp="DIFF_TOOL=kdiff3 ccase diff -pre"
alias dps="DIFF_TOOL=diff ccase diff -pre"
alias dh="DIFF_TOOL=kdiff3 ccase diff"
alias dhs="DIFF_TOOL=diff ccase diff"
alias lsspec="ls --color=never /view/aparco_main/vobs/utils/build/cspec"
alias grep="grep --color=auto"
alias lsproj="c lsproject -s -invob /vobs/fw-ucm"
alias cclinks="sudo /m/test_main/labconfig/admin/labify/conf/cclinks"
alias tpc="/m/test_main/fwtest/TLA/bin/tpc"
alias bsdftp="ftp fbsd-ftp"
alias cppcheck="USE_NONRECURSIVE_MAKE= make clean; USE_NONRECURSIVE_MAKE= make cppcheck"
alias makeclean="USE_NONRECURSIVE_MAKE= make -j 128 clean"

alias kamikaze="d fw; makeclean; rm -rf obj/; ccase sync; cd -"

alias _sfcm="sudo /usr/local/etc/rc.d/0001.svsfcm.sh"
alias _sfcd="sudo /usr/local/etc/rc.d/0004.svsfcd.sh"
alias _ptsm="sudo /usr/local/etc/rc.d/0003.svptsm.sh"
alias _ptsd="sudo /usr/local/etc/rc.d/0004.svptsd.sh"
alias _scdpd="sudo /usr/local/etc/rc.d/svscdpd.sh"
alias _sl="sudo /usr/local/etc/rc.d/0002.serviceLauncher.sh"
alias start_sfcd="_sl start; _scdpd start; _sfcm start; _sfcd start;"

export DIFF_TOOL=kdiff3
export CPU=SVOS9_64
export VISUAL="gvim --nofork"

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
	export VISUAL="vim"
    alias svup='sudo /usr/local/bin/svupdate -b3 -U ftp://ftp:ftp@lab-ftp:/released'
elif [ `uname` = "FreeBSD" ] ; then
    alias ls="ls -G"
    export LSCOLORS="ExCxcxdxBxegedabagacad"
elif [ `uname` = "Linux" ] ; then
    alias ls="ls --color=auto"
	export LS_COLORS="no=00:fi=00:di=00;94:ln=00;92:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;91:ow=00;94:"
elif [ `uname` = "CYGWIN_NT-6.1-WOW64" ] ; then
    export DISPLAY=localhost:0.0
elif [ `uname` = "Darwin" ] ; then
    alias ls="ls -G"
fi

alias res32k='tcl profilemgr -platform pts32k -projects ba-32k-latest -pkgExt .pts_ba_hw_dev -profile ptse -dur 18:30'
alias res22k='tcl profilemgr -platform pts22k -projects ba-32k-latest -pkgExt .pts_ba_hw_dev -profile ptse -dur 18:30'
alias res24k='tcl profilemgr -platform pts24k -projects ba-32k-latest -pkgExt .pts_ba_hw_dev -profile ptse -dur 18:30'
alias res14k='tcl profilemgr -platform pts14k -projects ba-32k-latest -pkgExt .pts_ba_hw_dev -profile ptse -dur 18:30'
alias partytime="lsres | grep 'Reservation' | awk '{print $2}' | xargs res rm"

if [ `uname` != "Linux" ] ; then
    alias tcl='/m/test_main/fwtest/bin/tcl'
	alias ls32k='tcl attrList -attr "mb_model SV67" -type mpc'
else
	alias tcl='ssh test ". /home/aparco/.bashrc;/m/test_main/fwtest/bin/tcl"'
	alias res='ssh test ". /home/aparco/.bashrc;/m/test_main/utils/svdev/all/bin/res"'
	alias ls32k='tcl attrList -attr \"mb_model SV67\" -type mpc'
fi

PATH=${HOME}/bin:/usr/local/bin:${HOME}/scripts:$PATH

CRST="\[\e[m\]"
CGREY="\[\e[38;5;240m\]"
CGREEN="\[\e[38;5;107m\]"
CBLUE="\[\e[38;5;110m\]"
CRED="\[\e[38;5;52m\]"

export PROMPT_DIRTRIM=1
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
            if [ $PROMPT_DIRTRIM -gt 0 -a $num -gt $(($PROMPT_DIRTRIM +1)) ] ; then
                _DVIEW="["$DVIEW"]"
            fi
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
    local check=0
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

rst()
{
	local host=
	host=$(_resolve_hostname $1)
	if [ "$(echo $host | wc -w)" -ne 1 ]; then
		echo "You probably didn't want to reset all these: $host"
		return 1
	fi
	if [ $? -eq 0 ] ; then
		echo "Resetting $host"
		tcl resource $host powerCycle
	else
		echo $host
	fi
}

view()
{
    echo $DVIEW
}

diffa()
{
    local activity=$(cleartool lsact -cact | awk '{print$2}')
    echo "Activity: $activity"
    if [ "$1" == "-s" ]; then
        DIFF_TOOL=diff ccase diff -act $activity
    else
        DIFF_TOOL=kdiff3 ccase diff -act $activity
    fi
}

execute_in_all_panes()
{
  # Notate which window/pane we were originally at
  ORIG_WINDOW_INDEX=`tmux display-message -p '#I'`
  ORIG_PANE_INDEX=`tmux display-message -p '#P'`
 
  # Assign the argument to something readable
  command=$1
 
  # Count how many windows we have
  windows=$((`tmux list-windows | wc -l`))
 
  # Loop through the windows
  for (( window=0; window <= $windows; window++ )); do
    tmux select-window -t $window #select the window
 
    # Count how many panes there are in the window
    panes=$((`tmux list-panes| wc -l`))
 
    # Loop through the panes that are in the window
    for (( pane=0; pane < $panes; pane++ )); do
      # Skip the window that the command was ran in, run it in that window last
      # since we don't want to suspend the script that we are currently running
      # and also we want to end back where we started..
      if [ $ORIG_WINDOW_INDEX -eq $window -a $ORIG_PANE_INDEX -eq $pane ]; then
          continue
      fi
      tmux select-pane -t $pane #select the pane
      tmux send-keys "$command" C-m
    done
  done
 
  tmux select-window -t $ORIG_WINDOW_INDEX #select the original window
  tmux select-pane -t $ORIG_PANE_INDEX #select the original pane
  #tmux send-keys "$command" C-m
}

refresh_display()
{
	execute_in_all_panes "export DISPLAY=$DISPLAY"
}

refresh_environment()
{
	execute_in_all_panes "source ~/.bashrc"
}
