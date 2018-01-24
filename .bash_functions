#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Wed 24 Jan 00:52:55 GMT 2018
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# If you got this file without using insit, then you probably should get/use init
# to update bashconfig, via the following commands, to avoid conflicts. This will
# of course blast away your current configurations:
#
#   sudo insit -S
#   sudo insit -U bashconfig
#----------------------------------------------------------------------------------

# Just in-case.
[ -z "$BASH_VERSION" ] && return 1

if [ -x /usr/bin/awk ]; then
	sc(){ printf "%f\n" "$(/usr/bin/awk "BEGIN{print($@)}" 2> /dev/null)"; }
fi

# Search the given path(s) for file types of TYPE. Ignores filename extension.
if [ -x /usr/bin/mimetype ]; then
	sif(){
		[ $# -eq 0 ] && printf "%s\n"\
			"USAGE: sif TYPE FILE1 [FILE2 FILE3...]" 1>&2

		TYPE="$1"
		shift

		for FILE in $@; {
			while read -a X; do
				for I in ${X[@]}; {
					#TODO - Why won't this match case?
					if [[ "$I" == $TYPE ]]; then
						printf "%s\n" "$FILE"
					fi
				}
			done <<< "$(/usr/bin/mimetype -bd "$FILE")"
		}
	}
fi

# Display the total data downloaded and uploaded on a given interface.
if [ -f /proc/net/dev ]; then
	inout(){
		while read -a X; do
			[ "${X[0]}" == "${1}:" ] && {
				IN=${X[1]}
				OUT=${X[9]}
			}
		done < /proc/net/dev

		printf "IN:  %'14dK\nOUT: %'14dK\n"\
			"$((IN/1024))" "$((OUT/1024))"
	}
fi

# Display the users on the system (parse /etc/passwd) in a more human-readable way.
if [ -f /etc/passwd ]; then
	lsusers(){
		printf "%-20s %-7s %-7s %-25s %s\n"\
			"USERNAME" "UID" "GID" "HOME" "SHELL"

		while IFS=":" read -a X; do
			if [ "$1" == "--nosys" ]; then
				#TODO - Make this instead omit system ones by
				#       testing for the shell used.
				if [[ "${X[5]/\/home\/syslog}" == /home/* ]]; then
					printf "%-20s %-7d %-7d %-25s %s\n"\
						"${X[0]}" "${X[2]}" "${X[3]}"\
						"${X[5]}" "${X[6]}"
				fi
			else
				printf "%-20s %-7d %-7d %-25s %s\n" "${X[0]}"\
					"${X[2]}" "${X[3]}" "${X[5]}" "${X[6]}"
			fi
		done < /etc/passwd
	}
fi

# A simple dictionary lookup alias, similar to the look command.
[ -f /usr/share/dict/words -a -r /usr/share/dict/words ] && {
	dict(){
		while read -r X; do
			[[ "$X" == *${1}* ]] && printf "%s\n" "$X"
		done < /usr/share/dict/words
	}
}

# Two possibly pointless functions to single- or double-quote a string of text.
squo(){ printf "'%s'\n\" \"\$*"; }
dquo(){ printf "\"%s\"\n" "$*"; }

#TODO - Combine these two functions and make more concise somehow. Avoid date.
[ -x /usr/bin/git -a -x /bin/date ] && {
	log(){
		declare -i COUNT=0
		local RESULT=`/usr/bin/git log`

		[ "$RESULT" ] || return

		while read X; do
			#TODO - Include comment and name.
			[[ "$X" == Date:\ \ \ [A-Z][a-z][a-z]\ * ]] && {
				/bin/date -d "${X:8:24}" +%F\ \(%X\)
				COUNT+=1
			}
		done <<< "$RESULT"

		echo "TOTAL:    $COUNT"

		unset COUNT X
	}

	logttl(){
		printf "%-7s  %s\n" "COMMITS" "REPOSITORY"

		for DIR in *; {
			[ -d "$DIR" ] && {
				cd "$DIR"

				GET_TTLS=`GIT_LOG_ALIAS`
				[ -z "$GET_TTLS" ] && return

				#TODO - Finish this. If CWD is not root of repo, -
				#       then show only repo root's directory name.
				#declare -i INUM=0
				#for I in *; {
				#	[ "$I" == ".git" ] && {
				#		INUM+=1
				#		cd - > /dev/null
				#	}
				#}
				#
				#[ $INUM -eq 0 ] && DIR="${CWD}"

				while read -a REPLY; do
					[[ "$REPLY" == TOTAL:* ]] && {
						printf "%'-7d  %s\n"\
							"${REPLY[1]}" "${PWD//*\/}"
					}
				done <<< "$GET_TTLS"

				cd - > /dev/null
			}
		}
	}
}

#TODO - Add proper args to the function to allow removal of those old aliases.
# Display only a certain type of package. Use: ls{ess,req,opt,ext}pkg
[ -x /usr/bin/dpkg-query -a -x /usr/bin/column ] && {
	LS_PKG_TYPE(){
		while read -ra X; do
		        [ "${X[0]}" == "$2" ] && B+=(${X[1]}) || continue
		done <<< "$(/usr/bin/dpkg-query --show -f="\${$1} \${Package}\n" \*)"
		
		for P in ${B[@]}; {
		        declare -i M=0
		        Y+=($P)
		
		        for V in ${Y[@]}; {
		                [ "$V" == "$P" ] && M+=1
		        }
		
		        [ $M -eq 1 ] && echo "$P"
		}
	}

	alias lsesspkg='LS_PKG_TYPE Essential yes | /usr/bin/column'
	alias lsreqpkg='LS_PKG_TYPE Priority required | /usr/bin/column'
	alias lsoptpkg='LS_PKG_TYPE Priority optional | /usr/bin/column'
	alias lsextpkg='LS_PKG_TYPE Priority extra | /usr/bin/column'
	alias lsimppkg='LS_PKG_TYPE Priority important | /usr/bin/column'
}

# My preferred links2 settings. Also allows you to quickly search with DDG.
if [ -x /usr/bin/links2 ]; then
	l2(){
		/usr/bin/links2 -http.do-not-track 1 -html-tables 1\
			-html-tables 1 -html-numbered-links 1\
			http://duckduckgo.com/?q="$*"
	}
fi
