#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bashrc
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Wed  9 Feb 18:50:16 GMT 2022
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# Bash version 4.0 or greater is required.
#------------------------------------------------------------------------------

{ [[ -z $PS1 ]] || shopt -q restricted_shell; } && return

shopt -s checkwinsize globstar complete_fullquote extquote extglob\
     force_fignore hostcomplete interactive_comments xpg_echo promptvars\
     sourcepath progcomp autocd cdspell dirspell direxpand nocasematch\
     histappend cmdhist lithist

enable -n alias

set -o interactive-comments +o monitor -o hashall\
	-o braceexpand -o emacs -o histexpand -o posix

# Disable the ability to use Ctrl + S to stop the terminal output.
# This allows you to search forwards with that same binding.
stty stop ''

# ANSI color escape sequences. Useful else, not just the prompt.
C_Red='\e[2;31m';           C_BRed='\e[1;31m';          C_Green='\e[2;32m';
C_BGreen='\e[1;32m';        C_Yellow='\e[2;33m';        C_BYellow='\e[1;33m';
C_Grey='\e[2;37m';          C_Reset='\e[0m';            C_BPink='\e[1;35m';
C_Italic='\e[3m';           C_Blue='\e[2;34m';          C_BBlue='\e[1;34m';
C_Pink='\e[2;35m';          C_Cyan='\e[2;36m';          C_BCyan='\e[1;36m'

PROMPT_PARSER() {
	local X Z Line Desc GI Status Top NFTTL CWD StatusColor Line Top Branch\
		Buffer ModifiedFiles TTLCommits Basename Dirname Slashes GB TempColumns

	X=$1
	(( X == 0 )) && X=

	if git rev-parse --is-inside-work-tree &> /dev/null; then
		GI=(
			'≎' # Clean
			'≍' # Uncommitted changes
			'≭' # Unstaged changes
			'≺' # New file(s)
			'⊀' # Removed file(s)
			'≔' # Initial commit
			'∾' # Branch is ahead
			'⮂' # Fix conflicts
			'!' # Unknown (ERROR)
			'-' # Removed file(s)
		)

		Status=`git status 2> /dev/null`
		Top=`git rev-parse --show-toplevel`

		GitDir=`git rev-parse --git-dir`
		if [[ $GitDir == . || $GitDir == "${PWD%%/.git/*}/.git" ]]; then
			Desc="${C_BRed}∷  ${C_Grey}Looking under the hood..."
		else
			if [[ -n $Top ]]; then
				# Get the current branch name.
				IFS='/' read -a A < "$Top/.git/HEAD"
				GB=${A[${#A[@]}-1]}
			fi

			# The following is in a very specific order of priority.
			if [[ -z $(git rev-parse --branches) ]]; then
				Desc="${C_BCyan}${GI[5]}  ${C_Grey}Branch '${GB:-?}' awaits its initial commit."
			else
				while read -ra Line; do
					if [[ ${Line[0]}${Line[1]}${Line[2]} == \(fixconflictsand ]]; then
						Desc="${C_BCyan}${GI[7]}  ${C_Grey}Branch '${GB:-?}' has conflict(s)."
						break
					elif [[ ${Line[0]}${Line[1]} == Untrackedfiles: ]]; then
						NFTTL=0
						while read -a Line; do
							[[ ${Line[0]} == ?? ]] && (( NFTTL++ ))
						done <<< "$(git status --short)"
						printf -v NFTTL "%'d" $NFTTL

						Desc="${C_BCyan}${GI[3]}  ${C_Grey}Branch '${GB:-?}' has $NFTTL new file(s)."
						break
					elif [[ ${Line[0]} == deleted: ]]; then
						Desc="${C_BCyan}${GI[9]}  ${C_Grey}Branch '${GB:-?}' detects removed file(s)."
						break
					elif [[ ${Line[0]} == modified: ]]; then
						readarray Buffer <<< "$(git --no-pager diff --name-only)"
						printf -v ModifiedFiles "%'d" ${#Buffer[@]}
						Desc="${C_BCyan}${GI[2]}  ${C_Grey}Branch '${GB:-?}' has $ModifiedFiles modified file(s)."
						break
					elif [[ ${Line[0]}${Line[1]}${Line[2]}${Line[3]} == Changestobecommitted: ]]; then
						Desc="${C_BCyan}${GI[1]}  ${C_Grey}Branch '${GB:-?}' has changes to commit."
						break
					elif [[ ${Line[0]}${Line[1]}${Line[3]} == Yourbranchahead ]]; then
						printf -v TTLCommits "%'d" "${Line[7]}"
						Desc="${C_BCyan}${GI[6]}  ${C_Grey}Branch '${GB:-?}' leads by $TTLCommits commit(s)."
						break
					elif [[ ${Line[0]}${Line[1]}${Line[2]} == nothingtocommit, ]]; then
						printf -v TTLCommits "%'d" "$(git rev-list --count HEAD)"

						Desc="${C_BCyan}${GI[0]}  ${C_Grey}Branch '${GB:-?}' is $TTLCommits commit(s) clean."
						break
					fi
				done <<< "$Status"
			fi
		fi
	fi

	# 2021-06-13: Temporary block — just experimenting.
	if [[ -n $Desc ]]; then
		if [[ -n $X ]]; then
			PS1="\[${C_Reset}\]${Desc}\[${C_Reset}\]\n\[\e[91m\]${X} \[\e[0m\]\[\e[2;37m\]\$\[\e[0m\] "
		else
			PS1="\[${C_Reset}\]${Desc}\[${C_Reset}\]\n\[\e[2;37m\]\$\[\e[0m\] "
		fi
	else
		if [[ -n $X ]]; then
			PS1="\[${C_Reset}\]\[\e[91m\]${X} \[\e[0m\]\[\e[2;37m\]\$\[\e[0m\] "
		else
			PS1="\[${C_Reset}\]\[\e[2;37m\]\$\[\e[0m\] "
		fi
	fi
}

PROMPT_COMMAND='PROMPT_PARSER $?'

export HISTCONTROL='ignoreboth'
export HISTFILESIZE=0
export HISTSIZE=1000
export HISTTIMEFORMAT='[%F_%X]: '
export TIMEFORMAT='%3R'
export VBOX_USER_HOME="/media/$USER/VBox"
export LS_COLORS='fi=37:di=1;37:ln=90:mh=90:ex=3;2;37:no=1;37:mi=90:ow=91'
export GREP_COLOR='1;31'
export LESSSECURE=1
export PS_PERSONALITY='posix'
export SUDO_EDITOR='/usr/bin/rvim'
export TERM='xterm-256color'

# Values for shader caching for use in gaming.
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_PATH='/tmp/nvidia-shaders'
export __GL_THREADED_OPTIMIZATION=1

# Pretty-print man(1) pages.
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_so=$'\E[1;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'

UsrBashComp='/usr/share/bash-completion/bash_completion'
[[ -f $UsrBashComp && -r $UsrBashComp ]] && . "$UsrBashComp"

bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

BCFuncs="$HOME/.bash_functions"
[[ -f $BCFuncs && -r $BCFuncs ]] && . "$BCFuncs"

unset BCAliases BCFuncs UsrBashComp
