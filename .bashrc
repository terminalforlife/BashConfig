#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Fri  6 Apr 20:12:43 BST 2018
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

# Set this to false to not indicate that shell should abide by posix standards.
POSIX_MODE="true"

# If git is installed and you're in a git repository, then this .bashrc file will
# by default display various git-related information. Change to false to disable.
DO_GIT="true"

# Set this to false to disable the prefixed ../ where the current working directory
# is displayed, unless you're of course in /. Alignment should be maintained.
PREFIX_DIR="false"

# If you use my custom prompt, use these top and bottom prompt pointers. These do
# require the fonts-symbola package, if on Ubuntu, otherwise something similar.
# Leave either or both empty (or commented out) to omit them from the prompt.
TARR="⮣ "
BARR="⮡ "

# Show the icon representing the previous command's exit status.
SHOW_ICON="false"

#TODO - Fix this not working properly in Konsole, KDE Plasma 5.
# By default, you should see a rather nice prompt. If you want something simple, -
# akin to the Bourne Shell prompt, set this option to true.
SIMPLE="false"

# Instead of a simple prompt, use the standard, Debian PS1 prompt, if set to true.
STANDARD="false"

# Set ALT_PROMPT to true if you want to use one of the alternative prompts I've
# either written myself or pasted from random places online, just to add veriety.
ALT_PROMPT="false"

# Requires ALT_PROMPT to be true. Choose the type of alternative prompt to use.
# Let me know if you want your prompt to be listed here. Valid prompt types:
#
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

# If true, the manual pages will be endeavor to be colorful. The code for this
# setting is actually stored in: $HOME/.bash_functions
MAN_COLORS="true"

# Enter your chosen ShellPlugins here. They must exist in: $HOME/ShellPlugins/
# Each entry must be separated by spaces, so ensure you escape or quote filenames
# with spaces in them, or even special characters understood by the shell.
PLUGINS=(
	Terminal_Reminder         # Display reminders of user-specified dates.
	Bell_Alarm                # Run 'bell' for simple alarm using the x11 bell.
	Cleaner_RK_Scan           # Run 'rkc' to scan with rkhunter and chkrootkit.
	Load_File_Links2          # Run 'l2f FILE' to load a file with links2.
	Git_Status_All            # Run 'gitsa' to show repos which need action.
	Get_Bad_Hosts             # Run 'gbh' to download a list of bad domains.
	List_Signals              # Run 'lsssig' for another way to list signals.
	LSPKG_Set                 # Run 'lspkg-set' to list various package types.
	Loop_This                 # Run 'loop' followed by CMD(s) to loop them.
)

# WARNING: Changing code below, without knowledge of shell, could easily break it!
#          Be sure to also back up the above user settings if you plan on updating
#          this file with the bashconfig entry in insit.

#--------------------------------------------------------------MAIN SETS AND SHOPTS

if ! [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
        printf "ERROR: Bash version 4.0 or greater is required.\n"
	return 1
fi

if [ -d "$HOME/bin" ] && ! [[ "$PATH" == */home/"$USER"/bin* ]]; then
	# If the directory exists and isn't already in PATH, set it so.
	export PATH="/home/$USER/bin:${PATH}"
fi

# If not running interactively, or are in restricted mode, then ignore the rest.
{ ! [ "$PS1" ] || shopt -q restricted_shell; } && return

# These commands don't work with zsh.
if [ -z "$ZSH_VERSION" ]; then
	if ! [ "$DEFAULT_HISTORY" == "true" ]; then
		shopt -s histappend cmdhist lithist
		set -o histexpand
	fi

	shopt -s checkwinsize globstar complete_fullquote expand_aliases extquote\
		 extglob force_fignore hostcomplete interactive_comments xpg_echo\
		 promptvars sourcepath progcomp autocd cdspell dirspell direxpand\
		 nocasematch

	set -o interactive-comments -o monitor -o hashall -o braceexpand -o emacs

	[ "$POXIS_MODE" == "true" ] && set -o posix
fi

#-------------------------------------------------------------------USER SET CHECKS

for OPT in\
\
	SHOW_LINES:$SHOW_LINES DO_GIT:$DO_GIT BRANCH:$BRANCH COMMITS:$COMMITS\
	PREFIX_DIR:$PREFIX_DIR SIMPLE:$SIMPLE STANDARD:$STANDARD\
	POSIX_MODE:$POSIX_MODE MAN_COLORS:$MAN_COLORS SHOW_ICON:$SHOW_ICON
{
	if ! [[ "${OPT/*:}" == @(true|false) ]]; then
		printf "ERROR: Incorrect setting at: %s\n" "${OPT%:*}" 1>&2
	fi
}

#---------------------------------------------------------------CODE FOR THE PROMPT

# When \w is used in PS1, this will set ../ when beyond depth 1. (4.* or later)
[ "${BASH_VERSINFO[0]}" -ge 4 ] && PROMPT_DIRTRIM=1

if ! [ "$ALT_PROMPT" == "true" ]; then
	if [ "$SIMPLE" == "false" ]; then
		PROMPT_PARSER(){
			# Get the previous command's exit status and update icon.
			local P X=$?; printf -v X "%0.3d" "$X"
			if [ "$SHOW_ICON" == "true" ]; then
				[ $X -eq 0 ] && local A="  " || local A="  "
			fi

			if [ -x /usr/bin/git -a "$DO_GIT" == "true" ]\
			&& /usr/bin/git rev-parse --is-inside-work-tree > /dev/null 2>&1 ; then
				# Get a short, status description of the branch.
				U="Your branch is ahead of"
				declare -i L=0
				while read -ra Z; do
					L+=1

					#TODO - Fix empty when new branch.
					if [[ $L -eq 2  && "${Z[*]}" == "$U"* ]] || [ $L -eq 3 ]; then
						local GS="${Z[@]//[:\'.]/} "
						break
					fi
				done <<< "$(/usr/bin/git status 2> /dev/null)"
				[ "$GS" ] && GS="${GS% } "

				# Get the current branch name.
				if [ "$BRANCH" == "true" -a "$DO_GIT" == "true" ]; then
					while read -ra Z; do
						if [[ "${Z[@]}" == \*\ * ]]; then
							local GB=" [${Z[1]}] "
							break
						fi
					done <<< "$(/usr/bin/git branch 2> /dev/null)"
				fi

				# Count the number of commits.
				if [ "$COMMITS" == "true" -a "$DO_GIT" == "true" ]; then
					declare -i L=0
					while read -r; do
						[[ "$REPLY" == commit* ]] && L+=1
					done <<< "$(/usr/bin/git log 2> /dev/null)"
					[ $L -eq 0 ] || printf -v GC "(%'d) " "$L"
					#TODO - Needed? Appended above: && printf "\n"
				fi
			fi

			# Avoids showing "..//". The _PWD var is for prompt only.
			# Changing PWD directory also breaks features like "cd -".
			if [ "$PREFIX_DIR" == "true" ]; then
				[ "$PWD" == "/" ] && _PWD="/" || _PWD="../${PWD//*\/}"
			fi

			if [ "$SHOW_LINES" == "true" ]; then
				printf -v Y "%-.*d" "$COLUMNS"
				P+="\e\[[2;38m\]${Y//0/━}\n"
			fi

			[ "$TARR" ] && P+="\[\e[0m\]${TARR}\[\e[1;38m\]"
			P+="${X}${A}\[\e[2;33m\]${GB}\[\e[2;39m\]"
			P+="${GS/Your branch is }\[\033[2;32m\]${GC}"
			P+="\[\e[01;31m\]${_PWD/ }\[\e[0m\]"
			[ "$BARR" ] && P+="\[\033[0m\]\n${BARR}"

			# Set the main prompt, using info from above.
			if [ "$STANDARD" == "false" ]; then
				PS1="$P"
			elif [ "$STANDARD" == "true" ]; then
				PS1="\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ "
			fi
		}

		# Minor drawback to this method is the inability to reassign the
		# value of PS1, unless you first unset or clear this one.
		PROMPT_COMMAND='PROMPT_PARSER'
	else
		PS1="\$ "
	fi
else
	if [ "$ALT_TYPE" ]; then
		case "$ALT_TYPE" in
			dsuveges)
				PS1="\[\e[1;30m\]\A \u@\h\[\e[m\]:\[\e[1;32m\]\W\[\e[m\]$ " ;;
			*)
				printf "ERROR: Incorrect setting at: ALT_TYPE\n" 1>&2 ;;
		esac
	else
		printf "ERROR: Missing setting at: ALT_TYPE\n" 1>&2
	fi
fi

#---------------------------------------------------------------------------HISTORY

if [ "$DEFAULT_HISTORY" == "true" ]; then
	#HISTIGNORE="ls *:exit *:clear:cd *::pwd:history *"
	HISTTIMEFORMAT="[%F_%X]: "
	HISTCONTROL=ignoreboth
	HISTFILESIZE=0
	HISTSIZE=1000
fi

#--------------------------------------------------------------------SOURCE PLUGINS

FLIB="$HOME/ShellPlugins"
if [ -d "$FLIB" ]; then
	for FUNC in ${PLUGINS[@]}; {
		if [ -f "$FLIB/$FUNC" -a -r "$FLIB/$FUNC" ]; then
			source "$FLIB/$FUNC"
		fi
	}
fi

unset FLIB FUNC

#-------------------------------------------------------------ENVIRONMENT VARIABLES

# Set the location where various VirtualBox settings and your VMs are stored.
if [ -x /usr/bin/vboxsdl -a -x /usr/bin/vboxmanage ]; then
	export VBOX_USER_HOME="/media/$USER/Main Data/Linux Generals/VirtualBox VMs"
fi

# Set the format of the shell keyboard, time.
export TIMEFORMAT=">>> real %3R | user %3U | sys %3S | pcpu %P <<<"

# Set the colors to use for the ls command. This is a dark, simple theme.
export LS_COLORS="di=1;31:ln=2;32:mh=1;32:ex=1;33:"

# Remove /snap/bin from the end of the PATH. Uncomment if you need this, but
# removing the snap functionality (packages) should remove it from PATH anyway.
#export PATH="${PATH%:\/snap\/bin}"

# Set the terminal color.
export TERM="xterm-256color"

# Supposedly, this should be run after the above line, according to: man 1 tput
[ -x /usr/bin/tput ] && /usr/bin/tput init

# Set less and the pager to be more secure by disabling certain features.
[ -x /usr/bin/less ] && export LESSSECURE=1

# If sudo is found, set the sudo -e editor to rvim or rnano.
if [ -x /usr/bin/sudo ]; then
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
[ -f "$USRBC" -a -r "$USRBC" ] && source "$USRBC"

unset USRBC

#-------------------------------------------------------------------------TERMWATCH

# Enable termwatch; it logs whenever the current user opens a terminal.
if [ -x /usr/bin/tty ]; then
	CURTERM=`/usr/bin/tty`
	TERMWATCH_LOG="$HOME/.termwatch.log"
	if [ -f "$TERMWATCH_LOG" -a -w "$TERMWATCH_LOG" ]; then
		printf 'Using %s on %s at %(%F (%X))T as %s.\n' "${CURTERM:-Unknown}"\
			"(${TERM:-unknown})" -1 "$USER" >> "$TERMWATCH_LOG"
	fi

	unset TERMWATCH_LOG CURTERM
fi

#--------------------------------------------------------------------INPUT BINDINGS

bind -q forward-word 2>&1 > /dev/null || bind '"\e[1;5C": forward-word'
bind -q backward-word 2>&1 > /dev/null || bind '"\e[1;5D": backward-word'

#------------------------------------------------------SOURCE ALIASES AND FUNCTIONS

# If the user's .bash_aliases file is found, source it.
BASH_ALIASES="$HOME/.bash_aliases"
[ -f "$BASH_ALIASES" -a -r "$BASH_ALIASES" ] && . "$BASH_ALIASES"

# If the user's .bash_functions file is found, source it.
BASH_FUNCTIONS="$HOME/.bash_functions"
[ -f "$BASH_FUNCTIONS" -a -r "$BASH_FUNCTIONS" ] && . "$BASH_FUNCTIONS"

unset BASH_ALIASES BASH_FUNCTIONS

# vim: ft=sh noexpandtab colorcolumn=84 tabstop=8 noswapfile nobackup
