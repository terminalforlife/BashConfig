#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Fri 15 Sep 15:59:49 BST 2017
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
	if [[ `/usr/bin/tty` == /dev/tty+([0-9]) ]]
	then
		export PS1="→  " PS2=">  " PS3="-  " PS4="+  "
	else
		export PS1="➤  " PS2=">  " PS3="-  " PS4="+  "
	fi
fi

HISTCONTROL=ignoreboth; HISTTIMEFORMAT="[%F_%X]: "; HISTSIZE=1000; HISTFILESIZE=0

#----------------------------------------------------------------------------------

FLIB="$HOME/ShellPlugins"

if [ -d "$FLIB" ]
then
	for FUNC in\
	\
		DIR_Refresh Scrot_Move Safe_RM Cleaner_RK_Scan Command_Note_Search\
		Bell_Alarm LS_Core_Utils FFMPEG_Convert List_Signals Module_Look\
		Celsius_to_Fahrenheit Times_Table Load_File_Links2 Download_Upload\
		Create_VM Movie_Index_Filter
		
	{
		[ -f "$FLIB/$FUNC" ] && source "$FLIB/$FUNC"
	}
fi

unset FLIB FUNC

#----------------------------------------------------------------------------------

export VBOX_USER_HOME="/media/$USER/1TB Internal HDD/Linux Generals/VirtualBox VMs"
export PATH="${PATH%:\/snap\/bin}"
export LS_COLORS="di=1;31:ln=1;32:mh=00:ex=1;33:"
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
