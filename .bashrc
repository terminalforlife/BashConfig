#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Sun 22 Oct 00:05:14 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

# This is my .bashrc configuration file, but it has been written in such a way that
# other people could use it, too. I've included easy-to-use configuration options
# just below.
#
# Thank you for your interest.

#---------------------------------------------------------------------USER SETTINGS

# This is where you, the user, can change some settings within this .bashrc file.
# You won't need any programming knowledge or any major experience with a terminal.
# Know that "true" is on and "false" is off -- but only replace the words!

# If git is installed and you're in a git repository, then this .bashrc file will
# by default display various git-related information. Change to false to disable.
DO_GIT="true"

# Set this to false to disable the prefixed ../ where the current working directory
# is displayed, unless you're of course in /. Alignment should be maintained.
PREFIX_DIR="true"

# By default, you should see a rather nice prompt. If you want something simple, -
# akin to the Bourne Shell prompt, set this option to true.
SIMPLE_PROMPT="false"

# If DO_GIT is true, and this option is true, then the current, active branch will
# be shown if you're currently in a git repository.
BRANCH="true"

# If DO_GIT is true, and this option is true, then output the total number of
# commits in parentheses. This will be placed to the right of the status message.
COMMITS="true"

# By default, each prompt will be separated by a tidy set of lines. To disable this
# feature, even though it may be harder to see each, then just set this to false.
SHOW_LINES="false"

# WARNING: Changing code below, without knowledge of shell, could easily break it!

#--------------------------------------------------------------MAIN SETS AND SHOPTS

{ [ -d "$HOME/bin" ] && ! [[ "$PATH" == */home/"$USER"/bin* ]]; } && {
	# If the directory exists and isn't already in PATH, set it so.
	export PATH="/home/$USER/bin:${PATH}"
}

# The RHEL recommended umask for much more safety when creating new files and
# directories. This is the equivalent of octal 700 and 600 for directories and
# files, respectively; drwx------ and -rw-------.
umask 0077

# Set the maximum number of processes for the current user. May require root access
# depending on your setup. Needed root access in Ubuntu 17.10 with a similar setup.
# It seems to just needs root access to raise this value, but not lower it.
#ulimit -u 5000

# If not running interactively, then ignore the rest of the file.
[ -z "$PS1" ] && return


# Don't want to run these commands if using zsh.
[ -z "$ZSH_VERSION" ] && {
	# Sets various shell options. See: man bash
	shopt -s histappend checkwinsize globstar cmdhist complete_fullquote\
		 expand_aliases extquote extglob force_fignore hostcomplete\
		 interactive_comments promptvars sourcepath progcomp autocd\
		 cdspell dirspell direxpand lithist nocasematch xpg_echo

	# Sets additional shell options. See: help set
	set -o interactive-comments -o histexpand -o monitor\
	    -o hashall -o posix -o braceexpand -o emacs
}

#------------------------------------------------------------------PROMPT & HISTORY

for OPT in\
\
	SHOW_LINES:$SHOW_LINES DO_GIT:$DO_GIT BRANCH:$BRANCH COMMITS:$COMMITS\
	PREFIX_DIR:$PREFIX_DIR SIMPLE_PROMPT:$SIMPLE_PROMPT
{
	[[ "${OPT/*:}" == @(true|false) ]] || {
		echo "ERROR: Incorrect setting at: ${OPT%:*}" 1>&2
	}
}

{ [ "$SIMPLE_PROMPT" == "false" ] && [ -x /usr/bin/tty ]; } && {
	# Get the prompt information: Git, PWD, and $?.
	GET_PC(){
		local X=$?; X=`printf "%0.3d" "$X"`
		[ "$SHOW_LINES" == "true" ] && {
			local Y=`printf "%${COLUMNS}s\n" " "`
		}

		# Uses Debian/Ubuntu package: fonts-font-awesome
		[ $X -eq 0 ] && local A="  " || local A="  "

		if [ -x /usr/bin/git ] && [ "$DO_GIT" == "true" ]; then
			# Work in progress. Rework of the above.
			local GS=$(
				declare -i L=0
				while read -ra X; do
					L+=1

					# If on 2nd line.
					[ $L -eq 2 ] && {
						# Removing . or : at the
						# end, to keep it clean, -
						# sane, and consistent.
						printf "%s " "${X[@]//[:\'.]/}"
						break # No more lines.
					}
				done <<< "$(/usr/bin/git status 2> /dev/null)"
			)

			[ -n "$GS" ] && GS="${GS% } "

			{ [ "$BRANCH" == "true" -a "$DO_GIT" == "true" ]; } && {
				local GB=$(
					# Shows the active branch.
					while read -ra X; do
						[[ "${X[@]}" == \*\ * ]] && {
							printf " [%s] "  "${X[1]}"
						}
					done <<< "$(/usr/bin/git branch 2> /dev/null)"
				)
			}

			{ [ "$COMMITS" == "true" -a "$DO_GIT" == "true" ]; } && {
				local GC=$(
					# Count the number of commits.
					declare -i L=0
					while read -r; do
						[[ "$REPLY" == *commit* ]] && L+=1
					done <<< "$(/usr/bin/git log 2> /dev/null)"
					[ $L -eq 0 ] || echo "(${L}) " && echo ""
				)
			}
		fi

		# Avoids showing "..//". The _PWD var is for prompt only.
		# Changing PWD directory also breaks features like "cd -".
		if [ "$PREFIX_DIR" == "true" ]; then
			[ "$PWD" == "/" ] && _PWD="/" || _PWD="../${PWD//*\/}"
		fi

		# These will be concatenated; more readable code, sort of.
		if [ "$SHOW_LINES" == "true" ]; then
			local PA="\e\[[2;9;38m\]${Y}\n\[\e[0m\]╓╾ \[\e[1;38m\]"
		else
			local PA="\[\e[0m\]╓╾ \[\e[1;38m\]"
		fi

		local PB="${X}${A}\[\e[2;33m\]${GB}\[\e[2;39m\]"
		local PC="${GS/Your branch is }\[\033[2;32m\]${GC}"
		local PD="\[\e[01;31m\]${_PWD/ }\[\e[0m\]\[\033[0m\]\n╙╾ "

		# Set the main prompt, using info from above.
		PS1="${PA}${PB}${PC}${PD}"
	}

	# Use and keep updated the above prompt code.
	PROMPT_COMMAND='GET_PC'
} || {
	# Just in-case, disable it.
	unset PROMPT_COMMAND

	# When \w is used in PS1, this will set ../ when beyond depth 1.
	#PROMPT_DIRTRIM=1

	# Set a simple prompt for being on a TTY, as in Bourne Shell.
	PS1="\$ "
}

# Sets the command history options. See: man bash
HISTCONTROL=ignoreboth; HISTTIMEFORMAT="[%F_%X]: "; HISTSIZE=1000; HISTFILESIZE=0

#--------------------------------------------------------------------SOURCE PLUGINS

# The location of the Shell Plugins sourced below.
FLIB="$HOME/ShellPlugins"

# If the above directory is found.
[ -d "$FLIB" ] && {
	# For each file specified here, within the above directory.
	for FUNC in\
	\
		Bell_Alarm Cleaner_RK_Scan Times_Table NIR_Difference\
		Load_File_Links2 CPU_Intensive_Procs Git_Status_All
	{

		# Source the file if it exists.
		[ -f "$FLIB/$FUNC" ] && . "$FLIB/$FUNC"
	}
}

unset FLIB FUNC

#-------------------------------------------------------------ENVIRONMENT VARIABLES

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

#------------------------------------------------------------SOURCE BASH_COMPLETION

USRBC="/usr/share/bash-completion/bash_completion"

# If the bash_completion file is found and has read access, source it.
{ [ -f "$USRBC" ] && [ -r "$USRBC" ]; } && source "$USRBC"

unset USRBC

#-------------------------------------------------------------------------TERMWATCH

# Enable a feature I dub termwatch. It logs whenever the current opens a terminal.
[ -x /usr/bin/tty ] && {
	TERMWATCH_LOG="$HOME/.termwatch.log"
	CURTERM=`/usr/bin/tty`
	DATE=`printf '%(%F (%X))T'`

	{ [ -f "$TERMWATCH_LOG" ] && [ -w "$TERMWATCH_LOG" ]; } && {
		# Using "" to avoid argument miscount when using %()T.
		printf 'Using %s on %s at %s as %s.\n' "${CURTERM:-Unknown}"\
			"(${TERM-unknown})" "$DATE" "$USER" >> "$TERMWATCH_LOG"
	}

	unset TERMWATCH_LOG CURTERM
}

#---------------------------------------------------------------SOURCE BASH_ALIASES

# If the user's bash_aliases file is found, source it.
BASH_ALIASES="$HOME/.bash_aliases"
{ [ -f "$BASH_ALIASES" ] && [ -r "$BASH_ALIASES" ]; } && . "$BASH_ALIASES"

unset BASH_ALIASES

#-------------------------------------------------------------------UNSET USER SETS

unset DO_GIT PREFIX_DIR SIMPLE_PROMPT BRANCH COMMITS SHOW_LINES
