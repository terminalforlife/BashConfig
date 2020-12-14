#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bashrc
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Mon 14 Dec 01:08:24 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# Bash version 4.0 or greater is required.
#------------------------------------------------------------------------------

{ ! [ "$PS1" ] || shopt -q restricted_shell; } && return

shopt -s checkwinsize globstar complete_fullquote expand_aliases extquote\
	 extglob force_fignore hostcomplete interactive_comments xpg_echo\
	 promptvars sourcepath progcomp autocd cdspell dirspell direxpand\
	 nocasematch histappend cmdhist lithist

set -o interactive-comments +o monitor -o hashall\
	-o braceexpand -o emacs -o histexpand -o posix

# Needed to ensure the git stuff shows correctly. In 18.04, the git
# version has slightly different output, so needed a workaround.
readarray T < /etc/lsb-release
[ "${T[2]#*=}" == bionic$'\n' ] && R=4 || R=3

# ANSI color escape sequences. Useful else, not just the prompt.
C_Red='\e[2;31m';       C_BRed='\e[1;31m';      C_Green='\e[2;32m';
C_BGreen='\e[1;32m';    C_Yellow='\e[2;33m';    C_BYellow='\e[1;33m';
C_Grey='\e[2;37m';      C_Reset='\e[0m';        C_BPink='\e[1;35m';
C_Italic='\e[3m';       C_Blue='\e[2;34m';      C_BBlue='\e[1;34m';
C_Pink='\e[2;35m';      C_Cyan='\e[2;36m';      C_BCyan='\e[1;36m'

PROMPT_PARSER(){
	if git rev-parse --is-inside-work-tree &> /dev/null; then
		local Status=`git status -s`
		if [ -n "$Status" ]; then
			local StatusColor=$C_BRed
		else
			local StatusColor=$C_BGreen
		fi

		local Top=`git rev-parse --show-toplevel`
		read Line < "$Top"/.git/HEAD
		local Branch="$C_Italic$StatusColor${Line##*/}$C_Reset "
	fi

	if [ $1 -gt 0 ]; then
		local Exit="$C_BRed🗴$C_Reset"
	else
		local Exit="$C_BGreen🗸$C_Reset"
	fi

	local Basename=${PWD##*/}
	local Dirname=${PWD%/*}

	if [ "$Dirname/$Basename" == '/' ]; then
		printf -v CWD "$C_Italic$C_BGreen/$C_Reset"
	else
		CWD="$C_Grey$Dirname/$C_Italic$C_BGreen$Basename$C_Reset"

		# If the CWD is too long, just show basename with '.../' prepended, if
		# it's valid to do so. I think ANSI escape sequences are being counted
		# in its length, causing it not work as it should, but I like the
		# result, none-the-less.
		local Slashes=${CWD//[!\/]/}
		TempColumns=$((COLUMNS + 40)) # <-- Seems to work around sequences.
		if [ ${#CWD} -gt $(((TempColumns - ${#Branch}) - 2)) ]; then
			if [ ${#Slashes} -ge 2 ]; then
				CWD="$C_Grey.../$C_Reset$C_BGreen$Basename$C_Reset"
			else
				CWD="$C_BGreen$Basename$C_Reset"
			fi
		fi
	fi

	PS1="$Exit $Branch$CWD\n: "

	unset Line
}

PROMPT_COMMAND='PROMPT_PARSER $?'

export HISTTIMEFORMAT='[%F_%X]: '
export HISTCONTROL='ignoreboth'
export HISTFILESIZE=0
export HISTSIZE=1000
export VBOX_USER_HOME="/media/$USER/Main Data/Linux Generals/VirtualBox VMs"
export TIMEFORMAT='>>> real %3R | user %3U | sys %3S | pcpu %P <<<'

# Created this theme on 2020-03-01, using various shades (not 50!) of grey.
export LS_COLORS='fi=0;37:di=1;37:ln=1;30:mh=1;30:ex=7;1;30:no=1;37:or=1;30:mi=1;30'

# Not using this anymore, as of 2020-03-01. I absolutely love this theme and
# have used it pretty much the entire time since I found Linux. Thanks to
# YouTube's compression (or some other weirdness) people watching my channel
# can't easily see the red text. :(
#export LS_COLORS='di=1;31:ln=2;32:mh=1;32:ex=1;33:'

export PATH=${PATH%:/snap/bin}
export TERM='xterm-256color'
export LESSSECURE=1
export SUDO_EDITOR='/usr/bin/rvim'
export GREP_COLOR='1;31'
export PS_PERSONALITY='posix'

# Yep, an unnecessarily-complicated solution! Proof of concept, I guess.
for Less in\
\
    'mb:\e[1;31m' 'md:\e[1;31m' 'me:\e[0m' 'ue:\e[0m'\
    'so:\e[1;33m' 'se:\e[0m' 'us:\e[1;32m'
{
    LessIdentifier="LESS_TERMCAP_${Less%:*}"
    printf -v $LessIdentifier '%b' "${Less#*:}"
    export $LessIdentifier
}

UsrBashComp="/usr/share/bash-completion/bash_completion"
[ -f "$UsrBashComp" -a -r "$UsrBashComp" ] && . "$UsrBashComp"

bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

BCAliases="$HOME/.bash_aliases"
[ -f "$BCAliases" -a -r "$BCAliases" ] && . "$BCAliases"

BCFuncs="$HOME/.bash_functions"
[ -f "$BCFuncs" -a -r "$BCFuncs" ] && . "$BCFuncs"

unset BCAliases BCFuncs UsrBashComp
