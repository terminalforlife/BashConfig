#!/usr/bin/env bash

#----------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Sun 19 Jan 02:46:08 GMT 2020
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

# Needed to ensure the git stuff shows correctly. In 18.04, the git
# version has slightly different output, so needed a workaround.
readarray T < /etc/lsb-release
[ "${T[2]#*=}" == bionic$'\n' ] && R=4 || R=3

PROMPT_PARSER(){
	printf -v X "%.3d" $?

	BRed='\033[1;31m'
	White='\033[2;37m'
	Reset='\033[0m'

	if git rev-parse --is-inside-work-tree &> /dev/null; then
		GI[0]='≎' # Clean.
		GI[1]='≍' # Uncommitted changes.
		GI[2]='≭' # Unstaged changes.
		GI[3]='≺' # New file(s).
		GI[4]='⊀' # Removed file(s).
		GI[5]='≔' # Initial commit.
		GI[6]='∾' # Branch is ahead.
		GI[7]='⮂' # Fix conflicts.
		GI[8]='!' # Unknown (ERROR).

		Status=`git status 2> /dev/null`
		Top=`git rev-parse --show-toplevel`
		printf -v Desc "${BRed}∷  ${White}Looking under the hood..."

		if [ -n "$Top" ]; then
			# Get the current branch name.
			IFS='/' read -a A < "$Top/.git/HEAD"
			GB=${A[${#A[@]}-1]}
		fi

		# While loops in special order:
		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}" == 'Initialcommit' ]; then
				Desc="${BRed}${GI[5]}  ${White}Branch '${GB:-?}' has no commits, yet."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[2]}" == '(fixconflictsand' ]; then
				Desc="${BRed}${GI[7]}  ${White}Branch '${GB:-?}' has conflict(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[2]}" == 'nothingtocommit,' ]; then
				TTLCommits=`git rev-list --count HEAD`

				Desc="${BRed}${GI[0]}  ${White}Branch '${GB:-?}' is $TTLCommits commit(s) clean."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[3]}" == 'Yourbranchahead' ]; then
				Desc="${BRed}${GI[6]}  ${White}Branch '${GB:-?}' leads by ${Z[7]} commit(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}" == 'Untrackedfiles:' ]; then
				#TODO: Sloppy method needs improving.
				declare -i NFTTL=0
				while read -a LINE; do
					[ "${LINE[0]}" == '??' ] && NFTTL+=1
				done <<< "$(git status --short)"

				Desc="${BRed}${GI[3]}  ${White}Branch '${GB:-?}' has $NFTTL new file(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}" == 'modified:' ]; then
				readarray Buffer <<< "$(git --no-pager diff --name-only)"

				Desc="${BRed}${GI[2]}  ${White}Branch '${GB:-?}' has ${#Buffer[@]} modified file(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[2]}${Z[3]}" == 'Changestobecommitted:' ]; then
				Desc="${BRed}${GI[1]}  ${White}Branch '${GB:-?}' has changes to commit."
				break
			fi
		done <<< "$Status"
		# End of specially-ordered while loops.
	else
		printf -v Desc "${BRed}☡  ${White}Sleepy git..."
	fi

	PS1="\[${Reset}\]╭──╼${X}╾──☉  ${Desc}\[${Reset}\]\n╰─☉  "
}

PROMPT_COMMAND='PROMPT_PARSER'

export HISTTIMEFORMAT="[%F_%X]: "
export HISTCONTROL='ignoreboth'
export HISTFILESIZE=0
export HISTSIZE=1000
export VBOX_USER_HOME="/media/$USER/Main Data/Linux Generals/VirtualBox VMs"
export TIMEFORMAT='>>> real %3R | user %3U | sys %3S | pcpu %P <<<'
export LS_COLORS='di=1;31:ln=2;32:mh=1;32:ex=1;33:'
export PATH=${PATH%:\/snap\/bin}
export TERM='xterm-256color'
export LESSSECURE=1
export SUDO_EDITOR="/usr/bin/rvim"
export GREP_COLOR="1;31"
export PS_PERSONALITY="posix"

UsrBashComp="/usr/share/bash-completion/bash_completion"
[ -f "$UsrBashComp" -a -r "$UsrBashComp" ] && . "$UsrBashComp"

bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

BCAliases="$HOME/.bash_aliases"
[ -f "$BCAliases" -a -r "$BCAliases" ] && . "$BCAliases"

BCFuncs="$HOME/.bash_functions"
[ -f "$BCFuncs" -a -r "$BCFuncs" ] && . "$BCFuncs"

unset BCAliases BCFuncs UsrBashComp X G Z Desc Status Top BRed White Reset
