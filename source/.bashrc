#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bashrc
#----------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Fri 24 Jan 02:51:21 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Bash version 4.0 or greater is required.
#----------------------------------------------------------------------------------

{ ! [ "$PS1" ] || shopt -q restricted_shell; } && return

shopt -s checkwinsize globstar complete_fullquote expand_aliases extquote\
	 extglob force_fignore hostcomplete interactive_comments xpg_echo\
	 promptvars sourcepath progcomp autocd cdspell dirspell direxpand\
	 nocasematch histappend cmdhist lithist

set -o interactive-comments +o monitor -o hashall\
	-o braceexpand -o emacs -o histexpand -o posix

PromptParser(){
	if [ $? -eq 0 ]; then
		Arrow='\[\e[2;31m\]:\[\e[0m\]'
	else
		Arrow='\[\e[1;31m\]:\[\e[0m\]'
	fi

	PS1="${Arrow}"

	unset Arrow
}

PROMPT_COMMAND='PromptParser'

export HISTTIMEFORMAT="[%F_%X]: "
export HISTCONTROL='ignoreboth'
export HISTFILESIZE=0
export HISTSIZE=1000
export VBOX_USER_HOME="/media/$USER/Main Data/Linux Generals/VirtualBox VMs"
export TIMEFORMAT="{'real' => %3R, 'user' => %3U, 'sys' => %3S, 'pcpu' => %P}"
export LS_COLORS='di=1;31:ln=2;32:mh=1;32:ex=1;33:'
export PATH=${PATH%:\/snap\/bin}
export TERM='xterm-256color'
export LESSSECURE=1
export SUDO_EDITOR="/usr/bin/rvim"
export GREP_COLOR="1;31"
export PS_PERSONALITY="posix"

bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

UsrBashComp="/usr/share/bash-completion/bash_completion"
[ -f "$UsrBashComp" -a -r "$UsrBashComp" ] && . "$UsrBashComp"

BCAliases="$HOME/.bash_aliases"
[ -f "$BCAliases" -a -r "$BCAliases" ] && . "$BCAliases"

BCFuncs="$HOME/.bash_functions"
[ -f "$BCFuncs" -a -r "$BCFuncs" ] && . "$BCFuncs"

unset BCAliases BCFuncs UsrBashComp
