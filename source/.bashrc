#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bashrc
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bashrc
# Started On        - Thu 14 Sep 12:44:56 BST 2017
# Last Change       - Sat  1 Jul 07:44:42 BST 2023
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# Bash version 4.0 or greater is required.
#
# Features:
#
# N/A
#
# Bugs:
#
#TODO: Git prompt kicks in with 'Unrecognised fatal error' if the CWD no longer
#      exists. This error can perhaps be ignored, by checking for this specific
#      situation and therefore exception.
#------------------------------------------------------------------------------

{ [[ -z $PS1 ]] || shopt -q restricted_shell; } && return

shopt -s checkwinsize globstar complete_fullquote extquote extglob\
	force_fignore hostcomplete xpg_echo promptvars sourcepath progcomp autocd\
	cdspell dirspell direxpand nocasematch histappend cmdhist lithist

enable -n alias

set -o interactive-comments +o monitor -o hashall\
	-o braceexpand -o emacs -o histexpand -o posix

# Disable the ability to use Ctrl + S to stop the terminal output.
# This allows you to search forwards with that same binding.
stty stop undef

# ANSI color escape sequences.
PROMPT_PARSER() {
	local X Z Line Desc GI Status Top NFTTL CWD StatusColor Line Top Branch\
		Buffer ModifiedFiles TTLCommits Basename Dirname Slashes GB\
		TempColumns WorkTreeChk SLevel Detached

	local C_BCyan='\e[96m' C_BRed='\e[91m' C_Reset='\e[0m'\
		C_Grey='\e[2;37m' C_Red='\e[31m'

	X="$1 "
	(( ${X% } == 0 )) && X=

	(( SHLVL > 1 )) && SLevel="\[$C_Grey\]<subshell>\[$C_Reset\] "

	# If I'm on a remote server, just use a barebones prompt, with the exit
	# status, if non-zero, and a note saying you're working remotely. Comment
	# this block out if you just want to use the exact same prompt.
	if [[ -n $SSH_CLIENT ]]; then
		if [[ -n $X ]]; then
			PS1="$SLevel\[$C_Grey\]<remote>\[$C_Reset\] \[$C_BRed\]$X\[$C_Reset\] \[$C_Grey\]\$\[$C_Reset\] "
		else
			PS1="$SLevel\[$C_Grey\]<remote>\[$C_Reset\] \[$C_Grey\]\$\[$C_Reset\] "
		fi

		return
	fi

	# The first check was added as a result of Issue #3 and a recent (April -
	# 2022) change to git(1) which was pushed in response to a CVE.
	WorkTreeChk=`git rev-parse --is-inside-work-tree 2>&1`
	if [[ $WorkTreeChk == 'fatal: unsafe repository '* ]]; then
		Desc="${C_BRed}!!  ${C_Grey}Unsafe repository detected."
	elif [[ $WorkTreeChk == 'fatal: '* ]]; then
		# Don't want to catch all fatals straight away, because not being in a
		# git(1) repository is a 'fatal' error -- stupid git(1).
		#
		# This lets me catch specific unwanted fatal errors, as well as general
		# fatal errors which are one of the specific ones.
		if [[ $WorkTreeChk != 'fatal: not a git repository '* ]]; then
			Desc="${C_BRed}!!  ${C_Grey}Unrecognised fatal error detected."
		fi
	elif [[ $WorkTreeChk == true ]]; then
		GI=(
			'≎' # 0: Clean
			'≍' # 1: Uncommitted changes
			'≭' # 2: Unstaged changes
			'≺' # 3: New file(s)
			'⊀' # 4: Removed file(s)
			'≔' # 5: Initial commit
			'∾' # 6: Branch is ahead
			'⮂' # 7: Fix conflicts
			'-' # 8: Removed file(s)
			'?' # 9: Head detacted
		)

		Status=`git status 2>&1`
		Top=`git rev-parse --show-toplevel 2>&1`

		GitDir=`git rev-parse --git-dir 2>&1`
		if [[ $GitDir == . || $GitDir == "${PWD%%/.git/*}/.git" ]]; then
			Desc="${C_BRed}∷  ${C_Grey}Looking under the hood..."
		else
			if [[ -n $Top ]]; then
				#IFS='/' read -a A < "$Top/.git/HEAD"
				#GB=${A[${#A[@]}-1]}
				# The above method is the old one, but it's much more
				# efficient. I'm not sure how to look for detacted HEAD with
				# this approach, hence the below approach.

				# Get the current branch name and look for detacted HEAD.
				GB=`git rev-parse --abbrev-ref HEAD 2>&-`
				if [[ $GB == HEAD ]]; then
					Desc="${C_BCyan}${GI[9]}  ${C_Grey}HEAD detached -- ouch."

					Detached='True'
				fi
			fi

			if [[ -z $(git rev-parse --branches 2>&1) ]]; then
				Desc="${C_BCyan}${GI[5]}  ${C_Grey}Awaiting initial commit."

				# The following is in a very specific order of priority.
				if [[ $Detached != True ]]; then
					while read -ra Line; do
						if [[ ${Line[0]}${Line[1]}${Line[2]} == \(fixconflictsand ]]; then
							Desc="${C_BCyan}${GI[7]}  ${C_Grey}Branch '${GB:-?}' has conflict(s)."
							break
						elif [[ ${Line[0]}${Line[1]} == Untrackedfiles: ]]; then
							NFTTL=0
							while read -a Line; do
								[[ ${Line[0]} == ?? ]] && (( NFTTL++ ))
							done <<< "$(git status --short 2>&1)"
							printf -v NFTTL "%'d" $NFTTL

							Desc="${C_BCyan}${GI[3]}  ${C_Grey}Branch '${GB:-?}' has $NFTTL new file(s)."
							break
						elif [[ ${Line[0]} == deleted: ]]; then
							Desc="${C_BCyan}${GI[8]}  ${C_Grey}Branch '${GB:-?}' detects removed file(s)."
							break
						elif [[ ${Line[0]} == modified: ]]; then
							readarray Buffer <<< "$(git --no-pager diff --name-only 2>&1)"
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
							printf -v TTLCommits "%'d" "$(git rev-list --count HEAD 2>&1)"

							Desc="${C_BCyan}${GI[0]}  ${C_Grey}Branch '${GB:-?}' is $TTLCommits commit(s) clean."
							break
						fi
					done <<< "$Status"
				fi
			fi
		fi
	fi

	if [[ -n $Desc ]]; then
		PS1="$SLevel\[${C_Reset}\]${Desc}\[${C_Reset}\]\n\[$C_BRed\]${X}\[$C_Reset\]\[$C_Grey\]\$\[$C_Reset\] "
	else
		PS1="$SLevel\[${C_Reset}\]\[$C_BRed\]${X}\[$C_Reset\]\[$C_Grey\]\$\[$C_Reset\] "
	fi
}

PROMPT_COMMAND='PROMPT_PARSER $?'

export HISTCONTROL='ignoreboth'
export HISTFILE=
#export HISTFILESIZE=0
export HISTSIZE=1000
export HISTTIMEFORMAT='[%F (%X)]: '
export TIMEFORMAT='%3R'
export VBOX_USER_HOME="/media/$USER/VBox"
export LS_COLORS='fi=37:di=1;97:ln=90:mh=90:ex=3;2;37:no=1;97:mi=90:ow=91'
export GREP_COLOR='1;91'
export LESSSECURE=1
export PS_PERSONALITY='posix'
export SUDO_EDITOR='/usr/bin/vim'
export TERM='xterm-256color'

# Values for shader caching for use in gaming.
#export __GL_SHADER_DISK_CACHE=1
#export __GL_SHADER_DISK_CACHE_PATH='/tmp/nvidia-shaders'
#export __GL_THREADED_OPTIMIZATION=1

# Pretty-print man(1) pages.
export LESS_TERMCAP_mb=$'\e[1;91m'
export LESS_TERMCAP_md=$'\e[1;91m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;93m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;92m'

UsrBashComp='/usr/share/bash-completion/bash_completion'
[[ -f $UsrBashComp && -r $UsrBashComp ]] && . "$UsrBashComp"

BCFuncs="$HOME/.bash_functions"
[[ -f $BCFuncs && -r $BCFuncs ]] && . "$BCFuncs"

unset BCAliases BCFuncs UsrBashComp
