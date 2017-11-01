#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Mon 30 Oct 21:28:12 GMT 2017
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

# Set this to false to not indicate that shell should above by posix standards.
POSIX_MODE="true"

# If git is installed and you're in a git repository, then this .bashrc file will
# by default display various git-related information. Change to false to disable.
DO_GIT="true"

# Set this to false to disable the prefixed ../ where the current working directory
# is displayed, unless you're of course in /. Alignment should be maintained.
PREFIX_DIR="false"

# By default, you should see a rather nice prompt. If you want something simple, -
# akin to the Bourne Shell prompt, set this option to true.
SIMPLE="false"

# Instead of a simple prompt, use the standard, Debian PS1 prompt, if set to true.
STANDARD="false"

# Set ALT_PROMPT to true if you want to use one of the alternative prompts I've
# either written myself or pasted from random places online, just to add veriety.
ALT_PROMPT="false"

# Requires ALT_PROMPT to be true. Choose the type of alternative prompt to use.
# Valid prompt types:
#                                          dsuveges - https://pastebin.com/T43WuZqU
ALT_TYPE="dsuveges"

# If DO_GIT is true, and this option is true, then the current, active branch will
# be shown if you're currently in a git repository.
BRANCH="true"

# If DO_GIT is true, and this option is true, then output the total number of
# commits in parentheses. This will be placed to the right of the status message.
COMMITS="true"

# By default, each prompt will be separated by a tidy set of lines. To disable this
# feature, even though it may be harder to see each, then just set this to false.
SHOW_LINES="true"

# Set this to true in order to remove all history settings and use the defaults.
DEFAULT_HISTORY="false"

# Enter your chosen ShellPlugins here. They must exist in: $HOME/ShellPlugins/
# Each entry must be separated by spaces, so ensure you escape or quote filenames
# with spaces in them, or even special characters understood by the shell.
PLUGINS=(Bell_Alarm Cleaner_RK_Scan Load_File_Links2 Git_Status_All List_Signals)

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


# These commands don't work with zsh.
[ -z "$ZSH_VERSION" ] && {
	[ "$DEFAULT_HISTORY" == "true" ] || {
		shopt -s histappend cmdhist lithist
		set -o histexpand
	}

	shopt -s checkwinsize globstar complete_fullquote expand_aliases extquote\
		 extglob force_fignore hostcomplete interactive_comments xpg_echo\
		 promptvars sourcepath progcomp autocd cdspell dirspell direxpand\
		 nocasematch

	set -o interactive-comments -o monitor -o hashall -o braceexpand -o emacs

	[ "$POXIS_MODE" == "true" ] && set -o posix
}

#----------------------------------------------------------------------------PROMPT

for OPT in\
\
	SHOW_LINES:$SHOW_LINES DO_GIT:$DO_GIT BRANCH:$BRANCH\
	COMMITS:$COMMITS PREFIX_DIR:$PREFIX_DIR\
	SIMPLE:$SIMPLE STANDARD:$STANDARD POSIX_MODE:$POSIX_MODE
{
	[[ "${OPT/*:}" == @(true|false) ]] || {
		echo "ERROR: Incorrect setting at: ${OPT%:*}" 1>&2
	}
}

# When \w is used in PS1, this will set ../ when beyond depth 1.
PROMPT_DIRTRIM=1

if ! [ "$ALT_PROMPT" == "true" ]; then
	if [ "$SIMPLE" == "false" ] && [ -x /usr/bin/tty ]; then
		# Get the prompt information: Git, PWD, and $?.
		GET_PC(){
			local X=$?; printf -v X "%0.3d" "$X"
			[ $X -eq 0 ] && local A="  " || local A="  "

			# This must come second to ensure $? above works.
			if [ "$SHOW_LINES" == "true" ]; then
				printf -v Y "%-.*d" "${COLUMNS}"
			fi

			if [ -x /usr/bin/git ] && [ "$DO_GIT" == "true" ]; then
				# Work in progress. Rework of the above.
				local GS=$(
					declare -i L=0
					while read -ra X; do
						L+=1

						# If on 2nd line.
						if [ $L -eq 2 ]; then
							# Removing . or : at the
							# end, to keep it clean, -
							# sane, and consistent.
							printf "%s " "${X[@]//[:\'.]/}"
							break # No more lines.
						fi
					done <<< "$(/usr/bin/git status 2> /dev/null)"
				)

				[ -n "$GS" ] && GS="${GS% } "

				if [ "$BRANCH" == "true" -a "$DO_GIT" == "true" ]; then
					local GB=$(
						# Shows the active branch.
						while read -ra X; do
							if [[ "${X[@]}" == \*\ * ]]; then
								printf " [%s] "  "${X[1]}"
							fi
						done <<< "$(/usr/bin/git branch 2> /dev/null)"
					)
				fi

				if [ "$COMMITS" == "true" -a "$DO_GIT" == "true" ]; then
					local GC=$(
						# Count the number of commits.
						declare -i L=0
						while read -r; do
							[[ "$REPLY" == commit* ]] && L+=1
						done <<< "$(/usr/bin/git log 2> /dev/null)"
						[ $L -eq 0 ] || printf "(%'d) " "$L" && echo ""
					)
				fi
			fi

			# Avoids showing "..//". The _PWD var is for prompt only.
			# Changing PWD directory also breaks features like "cd -".
			if [ "$PREFIX_DIR" == "true" ]; then
				[ "$PWD" == "/" ] && _PWD="/" || _PWD="../${PWD//*\/}"
			fi

			# These will be concatenated; more readable code, sort of.
			if [ "$SHOW_LINES" == "true" ]; then
				local PA="\e\[[2;38m\]${Y//0/━}\n\[\e[0m\]╓╾ \[\e[1;38m\]"
			else
				local PA="\[\e[0m\]╓╾ \[\e[1;38m\]"
			fi

			local PB="${X}${A}\[\e[2;33m\]${GB}\[\e[2;39m\]"
			local PC="${GS/Your branch is }\[\033[2;32m\]${GC}"
			local PD="\[\e[01;31m\]${_PWD/ }\[\e[0m\]\[\033[0m\]\n╙╾ "

			# Set the main prompt, using info from above.
			if [ "$STANDARD" == "false" ]; then
				PS1="${PA}${PB}${PC}${PD}"
			elif [ "$STANDARD" == "true" ]; then
				PS1="\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ "
			fi
		}

		# Use and keep updated the above prompt code.
		PROMPT_COMMAND='GET_PC'
	else
		# Set a simple prompt for being on a TTY, as in Bourne Shell.
		PS1="\$ "
	fi
else
	[ -n "$ALT_TYPE" ] && {
		case "$ALT_TYPE" in
			dsuveges)
				PS1="\[\e[1;30m\]\A \u@\h\[\e[m\]:\[\e[1;32m\]\W\[\e[m\]$ " ;;
			*)
				echo "ERROR: Incorrect setting at: ALT_TYPE" 1>&2 ;;
		esac
	} || echo "ERROR: Missing setting at: ALT_TYPE" 1>&2
fi

#---------------------------------------------------------------------------HISTORY

# Sets the command history options. See: man bash
[ "$DEFAULT_HISTORY" == "true" ] || {
	HISTIGNORE="ls *:exit *:clear:cd *::pwd:history *"
	HISTTIMEFORMAT="[%F_%X]: "
	HISTCONTROL=ignoreboth
	HISTFILESIZE=0
	HISTSIZE=1000
}

#--------------------------------------------------------------------SOURCE PLUGINS

# The location of the Shell Plugins sourced below.
FLIB="$HOME/ShellPlugins"

# If the above directory is found, then source each plugin, if it's found.
[ -d "$FLIB" ] && {
	for FUNC in ${PLUGINS[@]}; {
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
	printf -v DATE '%(%F (%X))T'

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
