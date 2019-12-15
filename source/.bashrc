#!/usr/bin/env bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Sun  1 Dec 01:42:16 GMT 2019
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
# Know that 'true' is on and 'false' is off -- but only replace the words!

# Set this to false to not indicate that shell should abide by posix standards.
POSIX_MODE='true'

# If git is installed and you're in a git repository, then this .bashrc file will
# by default display various pretty-printed git-related information. Change to
# false to disable.
DO_GIT='true'

# By default, you should see a rather nice prompt. If you want something simple, -
# akin to the Bourne Shell prompt, set this option to true.
SIMPLE='false'

# If DO_GIT is true, and this option is true, then the current, active branch will
# be shown if you're currently in a git repository.
BRANCH='true'

# Set this to true in order to remove all history settings and use the defaults.
DEFAULT_HISTORY='false'

# If true, the manual pages will be endeavor to be colorful. The code for this
# setting is actually stored in: $HOME/.bash_functions
MAN_COLORS='true'

# Enter your chosen .shplugs here. They must exist in: $HOME/.shplugs/
# Each entry must be separated by spaces, so ensure you escape or quote filenames
# with spaces in them, or even special characters understood by the shell.
PLUGINS=(gitsa)

# WARNING: Changing code below, without knowledge of shell, could easily break it!
#          Be sure to also back up the above user settings if you plan on updating
#          this file with the bashconfig entry in insit.

#--------------------------------------------------------------MAIN SETS AND SHOPTS

if ! [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
	printf "ERROR: Bash version 4.0 or greater is required.\n"
	return 1
fi

if [ -d "$HOME/bin" ] && ! [[ $PATH == *"/home/$USER/bin"* ]]; then
	# If the directory exists and isn't already in PATH, set it so.
	export PATH+=":/home/$USER/bin"
fi

# If not running interactively, or are in restricted mode, then ignore the rest.
{ ! [ "$PS1" ] || shopt -q restricted_shell; } && return

if [ "$DEFAULT_HISTORY" == 'false' ]; then
	shopt -s histappend cmdhist lithist
	set -o histexpand
fi

shopt -s checkwinsize globstar complete_fullquote expand_aliases extquote\
	 extglob force_fignore hostcomplete interactive_comments xpg_echo\
	 promptvars sourcepath progcomp autocd cdspell dirspell direxpand\
	 nocasematch

set -o interactive-comments +o monitor -o hashall -o braceexpand -o emacs

[ "$POSIX_MODE" == 'true' ] && set -o posix

#-------------------------------------------------------------------USER SET CHECKS

for OPT in\
\
	DO_GIT:$DO_GIT BRANCH:$BRANCH SIMPLE:$SIMPLE POSIX_MODE:$POSIX_MODE\
	MAN_COLORS:$MAN_COLORS
{
	if ! [[ ${OPT/*:} =~ ^(true|false)$ ]]; then
		printf "ERROR: Incorrect setting at: %s\n" "${OPT%:*}" 1>&2
	fi
}

#---------------------------------------------------------------CODE FOR THE PROMPT

# When \w is used in PS1, this will set ../ when beyond depth 1. (4.* or later)
[ "${BASH_VERSINFO[0]}" -ge 4 ] && PROMPT_DIRTRIM=1

if [ "$SIMPLE" == 'true' ]; then
	PS1="\$ "
else
	# Needed to ensure the git stuff shows correctly. In 18.04, the git
	# version has slightly different output, so needed a workaround.
	readarray T < /etc/lsb-release
	[ "${T[2]#*=}" == bionic$'\n' ] && R=4 || R=3
	#TODO: If file isn't found, should os-release be checked?

	# Newer, more concise prompt.
	PROMPT_PARSER(){
		printf -v X "%.3d" $?

		local P+="\[\e[0m\]╭──╼${X}╾──☉  "

		if [ "$DO_GIT" == 'true' ] && type -fP git > /dev/null 2>&1; then
			if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
				declare -a GI=()
				GI[0]='≎' # Clean.
				GI[1]='≍' # Uncommitted changes.
				GI[2]='≭' # Unstaged changes.
				GI[3]='≺' # New file(s).
				GI[4]='⊀' # Removed file(s).
				GI[5]='≔' # Initial commit.
				GI[6]='∾' # Branch is ahead.
				GI[7]='⮂' # Fix conflicts.
				GI[8]='!' # Unknown (ERROR).

				local STATUS=`git status 2> /dev/null`
				local TOP=`git rev-parse --show-toplevel`
				printf -v DESC "\e[1;31m∷  \e[2;37mLooking under the hood..."

				if [ "$BRANCH" == 'true' -a -n "$TOP" ]; then
					# Get the current branch name.
					IFS='/' read -a A < "$TOP/.git/HEAD"
					local GB=${A[${#A[@]}-1]}
				fi

				# While loops in special order:
				while read -ra Z; do
					if [ "${Z[0]}${Z[1]}" == 'Initialcommit' ]; then
						printf -v DESC "\e[1;31m%s\e[0m  \e[2;37mBranch '%s' has no commits, yet." "${GI[5]}" "${GB:-?}"
						break
					fi
				done <<< "$STATUS"

				while read -ra Z; do
					if [ "${Z[0]}${Z[1]}${Z[2]}" == '(fixconflictsand' ]; then
						printf -v DESC "\e[1;31m%s\e[0m  \e[2;37mBranch '%s' has conflict(s)." "${GI[7]}" "${GB:-?}"
						break
					fi
				done <<< "$STATUS"

				while read -ra Z; do
					if [ "${Z[0]}${Z[1]}${Z[2]}" == 'nothingtocommit,' ]; then
						local TTL_COMS=`git rev-list --count HEAD`
						printf -v DESC "\e[1;31m%s\e[0m  \e[2;37mBranch '%s' is %d commit(s) clean." "${GI[0]}" "${GB:-?}" "$TTL_COMS"
						break
					fi
				done <<< "$STATUS"

				while read -ra Z; do
					if [ "${Z[0]}${Z[1]}${Z[3]}" == 'Yourbranchahead' ]; then
						printf -v DESC "\e[1;31m%s\e[0m  \e[2;37mBranch '%s' leads by %d commit(s)." "${GI[6]}" "${GB:-?}" "${Z[7]}"
						break
					fi
				done <<< "$STATUS"

				while read -ra Z; do
					if [ "${Z[0]}${Z[1]}" == 'Untrackedfiles:' ]; then
						#TODO: Sloppy method needs improving.
						local LINE NFTTL=0
						while read -a LINE; do
							[ "${LINE[0]}" == '??' ] && let NFTTL+=1
						done <<< "$(git status --short)"

						printf -v DESC "\e[1;31m%s\e[0m  \e[2;37mBranch '%s' has %d new file(s)." "${GI[3]}" "${GB:-?}" "$NFTTL"
						break
					fi
				done <<< "$STATUS"

				while read -ra Z; do
					if [ "${Z[0]}" == 'modified:' ]; then
						local BUF
						readarray BUF <<< "$(git --no-pager diff --name-only)"
						printf -v DESC "\e[1;31m%s\e[0m  \e[2;37mBranch '%s' has %d modified file(s)." "${GI[2]}" "${GB:-?}" "${#BUF[@]}"
						break
					fi
				done <<< "$STATUS"

				while read -ra Z; do
					if [ "${Z[0]}${Z[1]}${Z[2]}${Z[3]}" == 'Changestobecommitted:' ]; then
						#TODO: Have a counter for this, too.
						printf -v DESC "\e[1;31m%s\e[0m  \e[2;37mBranch '%s' has changes to commit." "${GI[1]}" "${GB:-?}"
						break
					fi
				done <<< "$STATUS"
				# End of specially-ordered while loops.
			else
				printf -v DESC "\e[1;31m☡  \e[2;37mSleepy git..."
			fi
		fi

		P+="${DESC}\[\033[0m\]\n╰─☉  "

		PS1=$P

		unset X G Z DESC
	}
	# Minor drawback to this method is the inability to reassign the
	# value of PS1, unless you first unset or clear this one.
	PROMPT_COMMAND='PROMPT_PARSER'
fi

#---------------------------------------------------------------------------HISTORY

if [ "$DEFAULT_HISTORY" == 'false' ]; then
	#HISTIGNORE="ls *:exit *:clear:cd *::pwd:history *"
	HISTTIMEFORMAT="[%F_%X]: "
	HISTCONTROL='ignoreboth'
	HISTFILESIZE=0
	HISTSIZE=1000
fi

#--------------------------------------------------------------------SOURCE PLUGINS

FLIB="$HOME/.shplugs"
if [ -d "$FLIB" ]; then
	for FUNC in "${PLUGINS[@]}"; {
		if [ -f "$FLIB/$FUNC" ] && [ -r "$FLIB/$FUNC" ]; then
			. "$FLIB/$FUNC"
		fi
	}
fi

unset FLIB FUNC PLUGINS

#-------------------------------------------------------------ENVIRONMENT VARIABLES

# Set the location where various VirtualBox settings and your VMs are stored.
if type -fP vboxsdl vboxmanage > /dev/null 2>&1; then
	export VBOX_USER_HOME="/media/$USER/Main Data/Linux Generals/VirtualBox VMs"
fi

# Set the format of the shell keyboard, time.
export TIMEFORMAT='>>> real %3R | user %3U | sys %3S | pcpu %P <<<'

# Set the colors to use for the ls command. This is a dark, simple theme.
export LS_COLORS='di=1;31:ln=2;32:mh=1;32:ex=1;33:'

# Remove /snap/bin from the end of the PATH. Uncomment if you need this, but
# removing the snap functionality (packages) should remove it from PATH anyway.
#export PATH=${PATH%:\/snap\/bin}

# Set the terminal color.
export TERM='xterm-256color'

# Supposedly, this should be run after the above line, according to: man 1 tput
type -fP tput > /dev/null 2>&1 && /usr/bin/tput init

# Set less and the pager to be more secure by disabling certain features.
type -fP less > /dev/null 2>&1 && export LESSSECURE=1

# If sudo is found, set the sudo -e editor to rvim or rnano.
if type -fP sudo > /dev/null 2>&1; then
	if [ -x /usr/bin/rvim ]; then
		export SUDO_EDITOR="/usr/bin/rvim"
	elif [ -x /bin/rnano ]; then
		export SUDO_EDITOR="/bin/rnano"
	fi
fi

# Set the grep match color.
export GREP_COLOR="1;31"

# Made PS globally posixly correct, because why not?
export PS_PERSONALITY="posix"

#------------------------------------------------------------SOURCE BASH_COMPLETION

USRBC="/usr/share/bash-completion/bash_completion"
[ -f "$USRBC" -a -r "$USRBC" ] && . "$USRBC"

unset USRBC

#-------------------------------------------------------------------------TERMWATCH

# Enable termwatch; it logs whenever the current user opens a terminal.
if type -fP tty > /dev/null 2>&1; then
	CURTERM=`/usr/bin/tty`
	TERMWATCH_LOG="$HOME/.termwatch.log"
	if [ -f "$TERMWATCH_LOG" -a -w "$TERMWATCH_LOG" ]; then
		printf 'Using %s on %s at %(%F (%X))T as %s.\n' "${CURTERM:-Unknown}"\
			"(${TERM:-unknown})" -1 "$USER" >> "$TERMWATCH_LOG"
	fi

	unset TERMWATCH_LOG CURTERM
fi

#--------------------------------------------------------------------INPUT BINDINGS

bind -q forward-word > /dev/null 2> /dev/null || bind '"\e[1;5C": forward-word'
bind -q backward-word > /dev/null 2> /dev/null || bind '"\e[1;5D": backward-word'

#------------------------------------------------------SOURCE ALIASES AND FUNCTIONS

# If the user's .bash_aliases file is found, source it.
BASH_ALIASES="$HOME/.bash_aliases"
[ -f "$BASH_ALIASES" -a -r "$BASH_ALIASES" ] && . "$BASH_ALIASES"

# If the user's .bash_functions file is found, source it.
BASH_FUNCTIONS="$HOME/.bash_functions"
[ -f "$BASH_FUNCTIONS" -a -r "$BASH_FUNCTIONS" ] && . "$BASH_FUNCTIONS"

unset BASH_ALIASES BASH_FUNCTIONS

