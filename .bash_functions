#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Sat 17 Feb 22:14:56 GMT 2018
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

# An alternative way to get and display the session uptime.
if [ -f /proc/uptime -a -r /proc/uptime ]; then
	up(){
		read -a X < /proc/uptime
		declare -i H=$((${X[0]%.*}/60/60))
		declare -i M=$((${X[0]%.*}/60-(H*60)))
		P(){ [ $1 -gt 1 -o $1 -eq 0 ] && printf "s"; }
		printf "UP: $H hour%s and $M minute%s.\n" `P $H` `P $M`

		unset X
		unset -f P
	}
fi

# An improvement of a code block found here:
# https://forums.linuxmint.com/viewtopic.php?f=47&t=263770&p=1432658#p1432285
suppress(){
	$1 |& while read X; do
		[ "${X/$2}" ] && printf "%s\n" "${X/$2}"
	done

	return ${PIPESTATUS[0]}

	unset X
}

# Search for & output files not found which were installed with a given package.
if [ -x /usr/bin/dpkg-query ]; then
	missing-pkg-files(){
		while read X; do
			[ -e "$X" -a "$X" ] || printf "%s\n" "$X"
		done <<< "$(/usr/bin/dpkg-query -L $@)"

		unset X
	}
fi

# The ago function is a handy alias for apt-get's -o options.
if [ -x /usr/bin/apt-get ]; then
	ago(){
		#TODO - Why is there that initial blank line!?
		for FIELD in `/bin/zcat /usr/share/man/man8/apt-get.8.gz`; {
			if [[ "$FIELD" =~ ^(Dir|Acquire|Dpkg|APT):: ]]; then
				CLEAN="${FIELD//[.\\&)(,]}"
				[ "$OLD" == "$CLEAN" ] || printf "%s\n" "$OLD"
				OLD="$CLEAN"
			fi
		}

		unset FIELD CLEAN OLD
	}
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

		unset TYPE FILE X I
	}
fi

# Display the total data downloaded and uploaded on a given interface.
if [ -f /proc/net/dev ]; then
	inout(){
		while read -a X; do
			if [ "${X[0]}" == "${1}:" ]; then
				declare -i IN=${X[1]}
				declare -i OUT=${X[9]}
			fi
		done < /proc/net/dev

		printf "IN:  %'14dK\nOUT: %'14dK\n" "$((IN/1024))" "$((OUT/1024))"

		unset X
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

		unset X
	}
fi

# A simple dictionary lookup function, similar to the look command.
if [ -f /usr/share/dict/words -a -r /usr/share/dict/words ]; then
	dict(){
		while read -r X; do
			[[ "$X" == *${1}* ]] && printf "%s\n" "$X"
		done < /usr/share/dict/words

		unset X
	}
fi

# Two possibly pointless functions to single- or double-quote a string of text.
squo(){ printf "'%s'\n\" \"\$*"; }
dquo(){ printf "\"%s\"\n" "$*"; }

#TODO - Combine these two functions and make more concise somehow. Avoid date.
if [ -x /usr/bin/git -a -x /bin/date ]; then
	log(){
		declare -i COUNT=0
		local RESULT=`/usr/bin/git log`

		[ "$RESULT" ] || return

		while read X; do
			#TODO - Include comment and name.
			if [[ "$X" == Date:\ \ \ [A-Z][a-z][a-z]\ * ]]; then
				/bin/date -d "${X:8:24}" +%F\ \(%X\)
				COUNT+=1
			fi
		done <<< "$RESULT"

		echo "TOTAL:    $COUNT"

		unset X
	}

	logttl(){
		printf "%-7s  %s\n" "COMMITS" "REPOSITORY"

		for DIR in *; {
			if [ -d "$DIR" ]; then
				cd "$DIR"

				local GET_TTLS=`GIT_LOG_ALIAS`
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
					if [[ "$REPLY" == TOTAL:* ]]; then
						printf "%'-7d  %s\n"\
							"${REPLY[1]}" "${PWD//*\/}"
					fi
				done <<< "$GET_TTLS"

				cd - > /dev/null
			fi
		}

		unset DIR
	}
fi

# My preferred links2 settings. Also allows you to quickly search with DDG.
if [ -x /usr/bin/links2 ]; then
	l2(){
		/usr/bin/links2 -http.do-not-track 1 -html-tables 1\
			-html-tables 1 -html-numbered-links 1\
			http://duckduckgo.com/?q="$*"
	}
fi

# vim: noexpandtab colorcolumn=84 tabstop=8 noswapfile nobackup
