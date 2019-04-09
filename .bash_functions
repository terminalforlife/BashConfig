#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Tue  9 Apr 19:01:36 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# If you got this file without using insit, then you probably should get/use init
# to update bashconfig, via the following commands, to avoid conflicts. This will
# of course blast away your current configurations:
#
#   sudo insit -S
#   sudo insit -U bashconfig
#
# IMPORTANT:
#
#   All functions you wish to be listed with lad (bashconfig/lad) MUST be
#   one-liners and have ' #: ' appended to each alias line, followed by its brief
#   description.
#
#   Those which you don't, must be at least 3 tabs in to be ignored by lad. This
#   may change in future versions of lad.
#----------------------------------------------------------------------------------

# Just in-case.
[ -z "$BASH_VERSION" ] && return 1

if [ -x /usr/bin/awk ]; then
	sc(){ #: Perform mathematical calculations via AWK.
		printf "%f\n" "$(/usr/bin/awk "BEGIN{print($@)}" 2> /dev/null)"
	}
fi

if [ -x /usr/bin/column ]; then
	builtins(){ #: Display a columnized list of bash builtins.
		while read -r; do
			printf "%s\n" "${REPLY/* }"
		done <<< "$(enable -a)" | /usr/bin/column
	}
fi

# Display the current DPI setting.
if [ -x /usr/bin/xdpyinfo ]; then
	dpi(){ #: Display the current DPI setting.
		while read -a X; do
			if [ "${X[0]}" == "resolution:" ]; then
				printf "%s\n" "${X[1]/*x}"
			fi
		done <<< "$(/usr/bin/xdpyinfo)"
	}
fi

if [ -x /usr/bin/sensors ]; then
	showfans(){ #: Show the available system fan speeds using sensors.
		while read; do
			if [[ "$REPLY" == *[Ff][Aa][Nn]*RPM ]]; then
				printf "%s\n" "$REPLY"
			fi
		done <<< "$(/usr/bin/sensors)"
	}
fi

# Get and display the distribution type. (original base first)
if [ -f /etc/os-release -a -r /etc/os-release ]; then
	distro(){ #: Get and display the distribution type.
		while read -a X; do
			if [[ "${X[0]}" == ID_LIKE=* ]]; then
				printf "%s\n" "${X[0]/*=}"; break
			elif [[ "${X[0]}" == ID=* ]]; then
				printf "%s\n" "${X[0]/*=}"; break
			fi
		done < /etc/os-release
	}
fi

# Very useful, quick function to scan the current directory, if you have clamscan.
if [ -x /usr/bin/clamscan -a -x /usr/bin/tee ]; then
	scan(){ #: Scan the CWD with clamscan. Logs in: ~/.scan_func.log
		{
			printf "SCAN_START: %(%F (%X))T\n" -1
			/usr/bin/clamscan --bell -r --no-summary -i\
				--detect-pua=yes --detect-structured=no\
				--structured-cc-count=3 --structured-ssn-count=3\
				--phishing-ssl=yes --phishing-cloak=yes\
				--partition-intersection=yes --detect-broken=yes\
				--block-macros=yes --max-filesize=256M\
				|& /usr/bin/tee -a $HOME/.scan_alias.log
		} |& /usr/bin/tee -a $HOME/.scan_func.log
	}
fi

# Grab a list of TODOs for git projects, per a specific method. This only works if
# you use "#T0D0 - Note message here" syntax for your TODOs, where "0" is "O". If
# you use a different style, but it's perfectly consistent, change the below match.
GIT="$HOME/GitHub/terminalforlife/Personal"
if [ -d "$GIT" -a -x /bin/grep ]; then
	todo(){ #: Grab list of TODOs from GitHub projects.
		if cd "$GIT"; then
			/bin/grep --color=auto -R\
				--exclude-dir=".git" "[#\"]TODO - "
			cd - 2>&1 > /dev/null
		fi
	}
fi

# Quick and dirty function to display a random note line from command notes.
if { [ "$USER" == "ichy" ] && [ $UID -eq 1000 ]; }\
&& { [ -x /bin/sed -a -x /bin/grep -a -x /usr/bin/shuf ]; }\
&& [ -f $HOME/Documents/TT/Useful_Commands ]; then
	get-random-note(){ #: Display a random note line from command notes.
		/bin/sed "1,/^#END/!d" $HOME/Documents/TT/Useful_Commands\
			| /bin/grep -v "^#"\
			| /bin/grep -v "^$"\
			| /usr/bin/shuf -n 1
	}
fi

# Display all of the 'rc' packages, as determined by dpkg, parsed by the shell.
# Using this within command substitution, sending it to apt-get, is very useful.
if [ -x /usr/bin/dpkg ]; then
	lsrc(){ #:Search for and list all 'rc' packages detected by dpkg.
		while read -a X; do
			if [ "${X[0]}" == "rc" ]; then
				printf "%s\n" "${X[1]}"
			fi
		done <<< "$(/usr/bin/dpkg -l)"
	}
fi

# Get the display's resolution, per the geometry propert of the root window. This
# doesn't seem to work in i3-wm, so don't enable getres() if in that. Probably
# won't work if you're using a mult-monitor setup.
if [ -x /usr/bin/xprop -a ! "$XDG_CURRENT_DESKTOP" == "i3" ]; then
	if ! [ "$DESKTOP_SESSION" == "i3" ]; then
		getres(){ #: Fetch the screen resolution via root window.
			local X P="_NET_DESKTOP_GEOMETRY"
			IFS="=" read -a X <<< "$(/usr/bin/xprop -root $P)"
			printf "Current Resolution: %dx%d\n" "${X[1]%,*}" "${X[1]/*, }"
		}
	fi
fi

# An alternative way to get and display the session uptime.
if [ -f /proc/uptime -a -r /proc/uptime ]; then
	up(){ #: Alternative way to display session uptime.
		read -a X < /proc/uptime
		declare -i H=$((${X[0]%.*}/60/60))
		declare -i M=$((${X[0]%.*}/60-(H*60)))
		P(){ [ $1 -gt 1 -o $1 -eq 0 ] && printf "s"; }
		printf "UP: $H hour%s and $M minute%s.\n" `P $H` `P $M`

		unset X
		unset -f P
	}
fi

# Use these environment variables only for man, to give him some color.
if [ "$MAN_COLORS" == "true" ] && [ -x /usr/bin/man ]; then
	man(){ #: Display man pages with a little color.
		LESS_TERMCAP_mb=$'\e[01;31m'\
		LESS_TERMCAP_md=$'\e[01;31m'\
		LESS_TERMCAP_me=$'\e[0m'\
		LESS_TERMCAP_se=$'\e[0m'\
		LESS_TERMCAP_so=$'\e[01;44;33m'\
		LESS_TERMCAP_ue=$'\e[0m'\
		LESS_TERMCAP_us=$'\e[01;32m'\
		/usr/bin/man $@
	}
fi

#TODO - The list doesn't seem to be complete.
#TODO - Fix the inability to pipe the output.
# Display a descriptive list of kernel modules.
if [ -x /sbin/lsmod -a -x /sbin/modinfo ]; then
	lsmodd(){ #: List and describe (most) detected kernel modules.
		local X Y
		while read -a X; do
			[ "${X[0]}" == "Module" ] && continue
			Y=`/sbin/modinfo -d "${X[0]}"`
			[ "$Y" ] && printf "%s - %s\n" "${X[0]}" "$Y"
		done <<< "$(/sbin/lsmod)"
	}
fi

# An improvement of a code block found here:
# https://forums.linuxmint.com/viewtopic.php?f=47&t=263770&p=1432658#p1432285
suppress(){ #: Execute command ($1) and omit specified ($2) output.
	$1 |& while read X; do
		[ "${X/$2}" ] && printf "%s\n" "${X/$2}"
	done
	unset X
	return ${PIPESTATUS[0]}
}

# Search for & output files not found which were installed with a given package.
if [ -x /usr/bin/dpkg-query ]; then
	missing-pkg-files(){ #: Check for missing files installed from a given package(s).
		local X
		while read X; do
			[ -e "$X" -a "$X" ] || printf "%s\n" "$X"
		done <<< "$(/usr/bin/dpkg-query -L $@)"
	}
fi

# The ago function is a handy way to output some of the apt-get's -o options.
if [ -x /usr/bin/apt-get -a -x /bin/zcat ]; then
	ago(){ #: List out various apt-get options for the -o flag.
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
	sif(){ #: Search given path(s) for files of a specified type.
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
	inout(){ #: Display total network data transfer this session.
		local X
		while read -a X; do
			if [ "${X[0]}" == "${1}:" ]; then
				declare -i IN=${X[1]}
				declare -i OUT=${X[9]}
				break
			fi
		done < /proc/net/dev

		printf "IN:  %'14dK\nOUT: %'14dK\n" "$((IN/1024))" "$((OUT/1024))"
	}
fi

# Display the users on the system (parse /etc/passwd) in a more human-readable way.
if [ -f /etc/passwd ]; then
	lsusers(){ #: List users on the system, according to '/etc/passwd'.
		printf "%-20s %-7s %-7s %-25s %s\n"\
			"USERNAME" "UID" "GID" "HOME" "SHELL"

		local X
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

# A simple dictionary lookup function, similar to the look command.
if [ -f /usr/share/dict/words -a -r /usr/share/dict/words ]; then
	dict(){ #: A dictionary tool akin to the look command.
		local X
		while read -r X; do
			[[ "$X" == *$1* ]] && printf "%s\n" "$X"
		done < /usr/share/dict/words
	}
fi

# Two possibly pointless functions to single- or double-quote a string of text.
squo(){ #: Surround ($@) text in single quotion marks.
	printf "'%s'\n\" \"\$*"
}

dquo(){ #: Surround ($@) text in double quotation marks.
	printf "\"%s\"\n" "$*"
}

# My preferred links2 settings. Also allows you to quickly search with DDG.
if [ -x /usr/bin/links2 ]; then
	l2(){ #: A tweaked links2 experience, opening with DuckDuckGo.
		/usr/bin/links2 -http.do-not-track 1 -html-tables 1\
			-html-tables 1 -html-numbered-links 1\
			http://duckduckgo.com/?q="$*"
	}
fi

# Prompt to somewhat programmatically rename each file within the current
# directory. To skip one, simply submit an empty string. Output is fairly quiet.
# Does not work recursively, nor will it try to name anything but files. Uses color
# in output to make it quick and easy to read; may not work on all terminals. The
# changes are made the moment you press Enter, so be mindful! Ctrl + C to cancel.
# Use OPT -d or --directories to instead match those.
if [ -x /bin/mv ]; then
	brn(){ #: Batch-rename a bunch of files or directories.
		printf "NOTE: To match directories instead, use -d|--directories OPTs.\n"

		while [ "$1" ]; do
			case "$1" in
				--directories|-d)
					USE_DIRS="true" ;;
				"")
					;;
				*)
					printf "ERROR: Incorrect argument(s) specified." ;;
			esac
			shift
		done

		declare -i NUM=0
		for FILE in *; {
			if { ! [ "$USE_DIRS" == "true" ] && [ -f "$FILE" ]; }\
			|| { [ "$USE_DIRS" == "true" ] && [ -d "$FILE" ]; }; then
				NUM+=1
				printf "\e[2;31mFILE:\e[0m %s\n" "$FILE"

				read -ep " >> "
				if [ "$REPLY" ]; then
					if /bin/mv "$FILE" "$REPLY" 2> /dev/null; then
						printf "\e[2;32mItem #%d successfully renamed.\e[0m\n" $NUM
					else
						printf "\e[2;31mUnable to rename item #%d.\e[0m\n" $NUM
					fi
				fi
			fi
		}
	}
fi

# vim: ft=sh noexpandtab colorcolumn=84 tabstop=8 noswapfile nobackup
