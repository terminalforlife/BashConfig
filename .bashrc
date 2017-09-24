#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Sun 24 Sep 03:56:12 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

if [ -d "$HOME/bin" ] && ! [[ "$PATH" == */home/"$USER"/bin* ]]
then
	export PATH="/home/$USER/bin:${PATH}"
fi

umask 0077

[ -z "$BASH_VERSION" ] && return

#----------------------------------------------------------------------------------

shopt -s histappend checkwinsize globstar cmdhist complete_fullquote\
	 expand_aliases extquote extglob force_fignore hostcomplete\
	 interactive_comments promptvars sourcepath progcomp autocd\
	 cdspell dirspell direxpand lithist nocasematch xpg_echo

set -o interactive-comments -o histexpand -o emacs\
    -o monitor -o hashall -o posix -o braceexpand

#----------------------------------------------------------------------------------

if type -P /usr/bin/tty &> /dev/null
then
	if [[ "$(/usr/bin/tty)" == /dev/pts/* ]]
	then
		PROMPT_COMMAND='
			X=$?; Y=`printf "%${COLUMNS}s" " "`
			[ $X -eq 0 ] && A="" || A=""

			if [ -d .git ] && type -P /usr/bin/git &> /dev/null
			then
				GIT=" `/usr/bin/git status --short 2> /dev/null` "
				[ "$GIT" == "  " ] && GIT=" "
			else
				GIT=" "
			fi

			printf -- "${Y// /-}\n \e[1;37m%0.3d${A}\e[1;33m${GIT}\e[01;31m${PWD}\e[0m" "$X"
		'
		
		export PS1=" \[\033[00m\]\n "
	else
		export PS1="$ "
	fi
fi

HISTCONTROL=ignoreboth; HISTTIMEFORMAT="[%F_%X]: "; HISTSIZE=1000; HISTFILESIZE=0

#----------------------------------------------------------------------------------

FLIB="$HOME/ShellPlugins"

if [ -d "$FLIB" ]
then
	for FUNC in\
	\
		Bell_Alarm Cleaner_RK_Scan Times_Table List_Signals NIR_Difference\
		Load_File_Links2 CPU_Intensive_Procs Git_Status_All;
	{
		[ -f "$FLIB/$FUNC" ] && source "$FLIB/$FUNC"
	}
fi

unset FLIB FUNC

#----------------------------------------------------------------------------------

export VBOX_USER_HOME="/media/$USER/1TB Internal HDD/Linux Generals/VirtualBox VMs"
export TIMEFORMAT=">>> real %3R | user %3U | sys %3S | pcpu %P <<<"
export LS_COLORS="di=1;31:ln=1;32:mh=00:ex=1;33:"
export PATH="${PATH%:\/snap\/bin}"
export TERM="xterm-256color"
export LESSSECURE=1

if type -P /usr/bin/sudo &> /dev/null
then
	if type -P /usr/bin/vim &> /dev/null
	then
		export SUDO_EDITOR="rvim"
	elif type -P /usr/bin/nano &> /dev/null
	then
		export SUDO_EDITOR="rnano"
	fi
fi

#----------------------------------------------------------------------------------

ETCBC="/etc/bash_completion"
USRBC="/usr/share/bash-completion/bash_completion"

if [ -f "$ETCBC" ]
then
	source "$ETCBC"
elif [ -f "$USRBC" ]
then
	source "$USRBC"
fi

unset ETCBC USRBC

#----------------------------------------------------------------------------------

if type -P /bin/date /usr/bin/tty &> /dev/null
then
	TERMWATCH_LOGFILE="$HOME/.termwatch.log"
	CURTERM=`/usr/bin/tty`

	if [ -f "$TERMWATCH_LOGFILE" ] && [ -w "$TERMWATCH_LOGFILE" ]
	then
		echo "Using ${CURTERM:-Unknown} (${TERM-unknown})"\
			"at `/bin/date` as $USER." >> "$TERMWATCH_LOGFILE"
	fi

	unset TERMWATCH_LOGFILE CURTERM
fi

#----------------------------------------------------------------------------------

BASH_ALIASES="$HOME/.bash_aliases"
if [ -f "$BASH_ALIASES" ] && [ -r "$BASH_ALIASES" ]
then
	source "$BASH_ALIASES"
fi

unset BASH_ALIASES
