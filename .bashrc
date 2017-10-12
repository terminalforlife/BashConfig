#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Thu 12 Oct 15:30:06 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

([ -d "$HOME/bin" ] && ! [[ "$PATH" == */home/"$USER"/bin* ]]) && {
	# If the directory exists and isn't already in PATH, set it so.
	export PATH="/home/$USER/bin:${PATH}"
}

# The RHEL recommended umask for much more safety when creating new files and
# directories. This is the equivalent of octal 700 and 600 for directories and
# files, respectively; drwx------ and -rw-------.
umask 0077

# Set the maximum number of processes for the current user.
ulimit -u 5000

# If not running interactively, then ignore the rest of the file.
[ -z "$BASH_VERSION" ] && return

#----------------------------------------------------------------------------------

# Sets various shell options. See: man bash
shopt -s histappend checkwinsize globstar cmdhist complete_fullquote\
	 expand_aliases extquote extglob force_fignore hostcomplete\
	 interactive_comments promptvars sourcepath progcomp autocd\
	 cdspell dirspell direxpand lithist nocasematch xpg_echo

# Sets additional shell options. See: help set
set -o interactive-comments -o histexpand -o emacs\
    -o monitor -o hashall -o posix -o braceexpand

#----------------------------------------------------------------------------------

[ -x /usr/bin/tty ] && {
	# If running in a TTY and not a PTS.
	[[ "$(/usr/bin/tty)" == /dev/pts/* ]] && {
		# Get the prompt information: Git, PWD, and $?.
		GET_PC(){
			local X=$?; X=`printf "%0.3d" "$X"`
			local Y=`printf "%${COLUMNS}s\n" " "`

			# Uses Debian/Ubuntu package: fonts-font-awesome
			[ $X -eq 0 ] && local A="" || local A=""

			if [ -x /usr/bin/git ]; then
				# Unnecessary, but keeps it tidy.
				local GETGIT=$(
					readarray REPLY <<< "$(
						/usr/bin/git status -s 2> /dev/null
					)"

					echo "${REPLY[0]}"
				)

				local GIT=" $GETGIT "

				# Just ensures the prompt spacing is correct.
				[ "$GIT" == "  " ] && local GIT=" "
			else
				local GIT=" "
			fi

			# These will be concatenated; more readable code, sort of.
			local PA="\e\[[1;9;37m\]${Y}\[\e[0m\]\n \[\e[1;37m\]"
			local PB="${X}${A}\[\e[1;33m\]${GIT}\[\e[01;31m\]${PWD}"
			local PC="\[\e[0m\] \[\033[00m\]\n "

			# Set the main prompt, using info from above.
			PS1="${PA}${PB}${PC}"
		}

		# Use and keep updated the above prompt code.
		PROMPT_COMMAND='GET_PC'
	} || {
		# Just in-case, disable it.
		unset PROMPT_COMMAND

		# When \w is used in PS1, this will set ../ when beyond depth 1.
		PROMPT_DIRTRIM=1

		# Set a simple prompt for being on a TTY, as in Bourne Shell.
		PS1="\$ "
	}
}

# Sets the command history options. See: man bash
HISTCONTROL=ignoreboth; HISTTIMEFORMAT="[%F_%X]: "; HISTSIZE=1000; HISTFILESIZE=0

#----------------------------------------------------------------------------------

# The location of the Shell Plugins sourced below.
FLIB="$HOME/ShellPlugins"

# If the above directory is found.
[ -d "$FLIB" ] && {
	# For each file specified here, within the above directory.
	for FUNC in\
	\
		Bell_Alarm Cleaner_RK_Scan Times_Table NIR_Difference\
		Load_File_Links2 CPU_Intensive_Procs Git_Status_All\
		Movie_Index_Filter;
	{
		
		# Source the file if it exists.
		[ -f "$FLIB/$FUNC" ] && . "$FLIB/$FUNC"
	}
}

unset FLIB FUNC

#----------------------------------------------------------------------------------

# Set the location where various VirtualBox settings and your VMs are stored.
export VBOX_USER_HOME="/media/$USER/1TB Internal HDD/Linux Generals/VirtualBox VMs"

# Set the format of the shell keyboard, time.
export TIMEFORMAT=">>> real %3R | user %3U | sys %3S | pcpu %P <<<"

# Set the colors to use for the ls command. This is a dark, simple theme.
export LS_COLORS="di=1;31:ln=2;32:mh=1;32:ex=1;33:"

# Remove /snap/bin from the end of the PATH.
export PATH="${PATH%:\/snap\/bin}"

# Set the terminal color.
export TERM="xterm-256color"

# Set less and the pager to be more secure by disabling certain features.
export LESSSECURE=1

# If sudo is found, set the sudo -e editor to rvim or rnano.
[ -x /usr/bin/sudo ] && {
	if [ -x /usr/bin/rvim ]; then
		export SUDO_EDITOR="/usr/bin/rvim"
	elif [ -x /bin/rnano ]; then
		export SUDO_EDITOR="/bin/rnano"
	fi
}

#----------------------------------------------------------------------------------

ETCBC="/etc/bash_completion"
USRBC="/usr/share/bash-completion/bash_completion"

# If the bash_completion file is found and has read access, source it.
([ -f "$ETCBC" ] && [ -r "$ETCBC" ] && . "$ETCBC") ||
([ -f "$USRBC" ] && [ -r "$USRBC" ] && . "$USRBC")

unset ETCBC USRBC

#----------------------------------------------------------------------------------

# Enable a feature I dub termwatch. It logs whenever the current opens a terminal.
[ -x /usr/bin/tty ] && {
	TERMWATCH_LOG="$HOME/.termwatch.log"
	CURTERM=`/usr/bin/tty`

	([ -f "$TERMWATCH_LOG" ] && [ -w "$TERMWATCH_LOG" ]) && {
		# Using "" to avoid argument miscount when using %()T.
		printf "Using %s on %s at %(%F (%X))T as %s.\n"\
			"${CURTERM:-Unknown}" "(${TERM-unknown})" ""\
			"$USER" >> "$TERMWATCH_LOG"
	}

	unset TERMWATCH_LOG CURTERM
}

#----------------------------------------------------------------------------------

# If the user's bash_aliases file is found, source it.
BASH_ALIASES="$HOME/.bash_aliases"
([ -f "$BASH_ALIASES" ] && [ -r "$BASH_ALIASES" ]) && . "$BASH_ALIASES"

unset BASH_ALIASES
