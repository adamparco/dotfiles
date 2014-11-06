# .bashrc
PATH=${HOME}/bin:/usr/local/bin:${HOME}/scripts:$PATH

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

LANG=en_US.utf8
LC_ALL=en_US.UTF-8

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

hg_ps1()
{
    hg prompt "{ on {branch}}{ at {bookmark}}{status}" 2> /dev/null
}

CRST="\[\e[m\]"
CGREY="\[\e[38;5;240m\]"
CGREEN="\[\e[38;5;107m\]"
CBLUE="\[\e[38;5;110m\]"
CRED="\[\e[38;5;52m\]"

PS1="$CRST$CGREY\u$CRST@$CGREEN\h$CBLUE[\W]$CRED\$(__git_ps1 \(%s\))$CRST\\$ "
PS2="$CRST$CGREY>$CRST "

PROMPT_COMMAND='history -a'

# Turn off Ctrl-S flow control binding, and allow for emacs Ctrl-s forward search
stty ixany
stty ixoff -ixon

set -o emacs
shopt -s checkwinsize
set completion-ignore-case on
set show-all-if-ambiguous on
set show-all-if-unmodified on
#bind '"\t":menu-complete'

# history settings
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups:erasedups
export HISTFILE=~/.bash_history_eternal
shopt -s histappend
shopt -s cmdhist
shopt -s histverify ## edit a recalled history line before executing
#shopt -s histreedit ## reedit a history substitution line if it failed
HISTIGNORE='ls:history:exit:jobs:fg:bg'

#alias tmux="TERM=screen-256color tmux -2"
alias tmux="tmux -2"
alias ssh="ssh -Y"
alias l="ls -la --color=auto"
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
alias grep="grep --color=auto"

export EDITOR="vim"
export VISUAL="gvim"


# colors
if [ `uname` = "FreeBSD" ] ; then
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

listtmux()
{
    if which tmux >/dev/null 2>&1 && [ -z "$TMUX" ] ; then
        if [ $(tmux list-sessions 2> /dev/null | wc -l) -gt 0 ]; then
            echo "Active tmux sessions:"
            tmux list-sessions
        else
            echo "No tmux sessions active."
        fi
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
