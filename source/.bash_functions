#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_functions
#----------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Sun 19 Jan 03:18:29 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# IMPORTANT: If you use `lad`, you need to read the contents of `lad --help` before
#            making any changes to this file, or risk breaking it's functionality.
#----------------------------------------------------------------------------------

if type -fP perl &> /dev/null; then
	perlc(){ #: Perform a syntax check on all Perl scripts within the CWD.
		local CurFile Line

		for CurFile in ./*; {
			if [ -f "$CurFile" ] && [ -r "$CurFile" ]; then
				read Line < "$CurFile"

				case $Line in
					'#!/*/perl'*|'#!/*/env perl'*)
						perl -c "$CurFile" ;;
				esac
			fi
		}
	}
fi

if [ -f /usr/lib/tflbp-sh/YNInput ]; then
	yesno(){ #: Output a discreet one-line prompt, using libtflbp-sh's `YNInput()`.
		(
			. /usr/lib/tflbp-sh/YNInput
			YNInput "$*" || return 1
		)
	}
fi

if type -fP git &> /dev/null; then
	pullupforks()( #: For all forks, pull upstream changes to the current branch.
		if [ $UID -eq 1000 -a "$USER" == 'ichy' ]; then
			GHForkDir="$HOME/GitHub/terminalforlife/Forks"
		else
			if [ -z "$1" ]; then
				printf "ERROR: The GitHub username is required.\n"
				return 1
			else
				# If not me, enter your GitHub forks path.
				GHForkDir=${1%/}
			fi
		fi

		# Pull, from upstream, each directory (repository) in GHForkDir.
		for CurDir in "$GHForkDir"/*; {
			if [ -d "$CurDir" ]; then
				cd "$CurDir" 2> /dev/null || continue

				# If not a git repo, go back, then skip to next iteration.
				if ! git rev-parse --is-inside-work-tree &> /dev/null; then
					cd "$GHForkDir" 2> /dev/null || return 1
					continue
				fi

				# Get the current branch name.
				IFS='/' read -a HeadArr < "$CurDir/.git/HEAD"
				GitBranch=${HeadArr[${#HeadArr[@]}-1]}

				if [ -z "$GitBranch" ]; then
					# If above fails, try old method.
					while read -ra CurLine; do
						if [[ ${CurLine[@]} == \*\ * ]]; then
							GitBranch=${CurLine[1]}
							break
						fi
					done <<< "$(git branch 2> /dev/null)"
				fi

				# If offline repo, above won't work, try:
				if [ -z "$GitBranch" ]; then
					read -a GitBranch <<< "$GitStatus"
					GitBranch=${GitBranch[2]}

					# If all else fails, bail.
					if [ -z "$GitBranch" ]; then
						printf "ERROR: Branch name detection failed.\n"
						continue
					fi
				fi

				printf "Repository '%s' updating... " "${CurDir##*/}"

				if git --no-pager pull upstream "$GitBranch" &> /dev/null; then
					printf "[\e[1;32mOK\e[0m]\n"
				else
					printf "[\e[1;31mERR\e[0m]\n"
				fi
			fi

			unset CurDir GHForkDir GitBranch GitStatus HeadArr
		}
	)
fi

if type -fP dmenu &> /dev/null; then
	dnote(){ #: Save a note to the desktop, using a simple form of dmenu.
		local File="$HOME/Desktop/Saved Notes.txt"
		if ! [ -f "$File" ]; then
			> "$File"
		else
			if ! [ -w "$File" ]; then
				printf "ERROR: No write access to notes file.\n"
				return 1
			fi
		fi

		local NOTE=`printf '' | dmenu -p 'NOTE:' -l 1`
		if [ -z "$NOTE" ]; then
			printf "ERROR: Cannot save an empty note.\n"
			return 1
		else
			printf "%(%F_%X)T: %s\n" -1 "$NOTE" >> "$File"
		fi
	}
fi

if type -fP grep uniq sed &> /dev/null; then
	gitgrep(){ #: Execute a configured grep command in git context.
		grep -sIr --exclude-dir='.git' --exclude='LICENSE' --exclude='README.md'\
			--exclude={.bash{_{aliases,functions,logout,profile},rc},{,.}inputrc,inputrc}\
			--exclude='*.'{mp3,jpg,ogg,png,deb,xml} --color=auto "$@"
	}

	noab(){ #: No absolutes for executables found in PATH directories and the given file.
		if ! [ -f "$1" -a -r "$1" -a -w "$1" ]; then
			printf "ERROR: File missing or insufficent permissions.\n"
			return 1
		fi

		printf "WARNING: The file will be irreversably changed!\n"
		read -n 1 -e -p "Press any key to continue, or Ctrl+C to cancel... "

		P=(`grep -Eo "(${PATH//://|})[a-Z0-9_-]+" "$1" 2> /dev/null | uniq 2> /dev/null`)
		for F in ${P[@]}; { sed -i "s|$F |${F##*/} |g" "$1" 2> /dev/null; }
	}
fi

if type -fP awk &> /dev/null; then
	# Inspired by 'paperbenni' on GitHub.
	if type -fP sha256sum &> /dev/null || type -fP md5sum &> /dev/null; then
		hash() { #: Fetch and compare the sha256 sums of two or more files.
			local I=`awk '{!A[$1]++} END{print(NR)}' <(sha256sum "$@" 2> /dev/null)`
			if [ $I -eq 0 ]; then
				printf "Usage: hash [FILE_1] [FILE_2] ...\n" >&2
				return 2
			elif [ $I -eq 1 ]; then
				return 1
			fi
		}
	elif type -fP md5sum &> /dev/null; then
		hash() { #: Fetch and compare the md5 sums of two or more files.
			local I=`awk '{!A[$1]++} END{print(NR)}' <(md5sum "$@" 2> /dev/null)`
			if [ $I -eq 0 ]; then
				printf "Usage: hash [FILE_1] [FILE_2] ...\n" >&2
				return 2
			elif [ $I -eq 1 ]; then
				return 1
			fi
		}
	fi

	topmem(){ #: Nice, brief, and clean output showing the top 50 memory-hogging processes.
		awk "
			{
				M=\$1/1024
				if(NR<50 && M>1){
					printf(\"%'7dM %s\\n\", M, \$2)
				}
			}
		" <<< "$(\ps ax -o rss= -o comm= --sort -rss)"
	}

	sc(){ #: Perform mathematical calculations via AWK.
		awk -SP "BEGIN{print($@)}" 2> /dev/null
	}
fi

if type -fP feh &> /dev/null; then
	bgtest(){ #: Cyclicly test-run all CWD JPGs as a background.
		declare -i NUM=0
		for CurFile in *$1*.jpg; {
			[ -f "$CurFile" ] || continue
			NUM+=1; [ $NUM -lt $2 ] && continue

			printf "\r%${COLUMNS}s\r%d: %s" ' ' "$NUM"  "$CurFile"
			feh --bg-center "$CurFile"
			read -n 1 -s
		}

		[ $NUM == 0 ] || printf "\n"

		unset CurFile
	}
fi

if type -fP mplayer &> /dev/null; then
	mpvi(){ #: In i3-wm, play a video inside the active window.
		tput smcup
		tput clear

		WID=`xprop -root _NET_ACTIVE_WINDOW | cut -d "#" -f 2`
		mplayer -msglevel "all=-1" -nolirc -wid "$WID" "$@" &> /dev/null

		# Addresses bug. The window will otherwise fill with last frame.
		wait; tput rmcup

		unset WID
	}

	if type -fP youtube-dl &> /dev/null; then
		syt(){ #: Stream a YouTube video directly into MPlayer.
			youtube-dl "$1" -o - 2> /dev/null | mplayer -vo x11 -nomouseinput\
				-noar -nojoystick -nogui -zoom -nolirc -really-quiet - &> /dev/null
		}
	fi
fi

if type -fP column &> /dev/null; then
	builtins(){ #: Display a columnized list of bash builtins.
		while read -r; do
			printf "%s\n" "${REPLY/* }"
		done <<< "$(enable -a)" | column
	}
fi

# Display the current DPI setting.
if type -fP xdpyinfo &> /dev/null; then
	dpi(){ #: Display the current DPI setting.
		while read -a X; do
			if [ "${X[0]}" == "resolution:" ]; then
				printf "%s\n" "${X[1]/*x}"
			fi
		done <<< "$(xdpyinfo)"
	}
fi

if type -fP sensors &> /dev/null; then
	showfans(){ #: Show the available system fan speeds using sensors.
		while read; do
			if [[ $REPLY == *[Ff][Aa][Nn]*RPM ]]; then
				printf "%s\n" "$REPLY"
			fi
		done <<< "$(sensors)"
	}
fi

# Get and display the distribution type. (original base first)
if [ -f /etc/os-release -a -r /etc/os-release ]; then
	distro(){ #: Get and display the distribution type.
		while read -a CurLine; do
			if [[ ${CurLine[0]} == ID_LIKE=* ]]; then
				printf "%s\n" "${CurLine[0]/*=}"; break
			elif [[ ${CurLine[0]} == ID=* ]]; then
				printf "%s\n" "${CurLine[0]/*=}"; break
			fi
		done < /etc/os-release

		unset CurLine
	}
fi

# Very useful, quick function to scan the current directory, if you have clamscan.
if type -fP clamscan tee &> /dev/null; then
	scan(){ #: Scan the CWD with clamscan. Logs in: ~/.scan_func.log
		printf 'Scanning...\n'

		clamscan --bell -zor --detect-pua=yes --detect-structured=no\
			--structured-cc-count=3 --block-macros=yes --phishing-ssl=yes\
			--structured-ssn-count=3 --phishing-cloak=yes --cross-fs=no\
			--partition-intersection=yes &> "$HOME/.scan_func.log"

		while IFS=':' read Key Value; do
			case $Key in
				'Infected files') Infected=${Value//[!0-9]} ;;
			esac
		done < "$HOME/.scan_func.log"

		if [ $Infected -eq 0 ]; then
			printf '\e[1;32mNothing found.\e[0m\n'
		else
			printf '\e[1;31mFound %d infection(s)!\e[0m\n' $Infected
		fi
	}
fi

# Display a random note line from command notes.
if [ "$USER" == 'ichy' -a $UID -eq 1000 ]; then
	if type -fP sed grep shuf &> /dev/null; then
		if [ -f "$HOME/Documents/TT/Useful_Commands" ]; then
			getrandomnote(){ #: Display a random note line from command notes.
				local InFile="$HOME/Documents/TT/Useful_Commands";
				if [ -f "$InFile" ] && [ -r "$InFile" ]; then
					# POSIX-ly incorrectly, sadly, because of `length()` on arrays.
					awk -S -v Rand="$RANDOM" '
						{
							if($1~/^#END$/&&NR>10){
								exit 0
							}else if($1!~/^(#|$)/){
								Array[$0]++
							}
						}

						END {
							Count=0
							for(Index in Array){
								Count++
								if(Count==Rand%length(Array)){
									printf("%s\n", Index)
									break
								}
							}
						}
					' "$InFile"
				fi
			}
		fi
	fi
fi

if type -fP dpkg &> /dev/null; then
	lsrc(){ #: Search for and list all 'rc' packages detected by dpkg.
		if [ $# -ne 0 ]; then
			printf 'ERROR: No arguments required.\n'
			return 1
		fi

		declare -a Total
		while read F1 F2 _; do
			[ "$F1" == 'rc' ] && Total+="$F2"
		done <<< "$(dpkg -l)"

		if [ ${#Total} -gt 0 ]; then
			printf '%s\n' $Total
		else
			printf 'No packages found.\n' 2>&1
		fi

		unset F1 F2 _
	}
fi

# Get the display's resolution.
if type -fP xwininfo &> /dev/null; then
	getres(){ #: Two viable methods for fetching the display resolution.
		while read -a LINE; do
			if [ "${LINE[0]}" == '-geometry' ]; then
				printf "Your resolution is %s, according to xwininfo.\n" "${LINE[1]%+*+*}"
			fi
		done <<< "$(xwininfo -root)"
	}
elif type -fP xdpyinfo &> /dev/null; then
	getres(){ #: Two viable methods for fetching the display resolution.
		while read -a LINE; do
			if [ "${LINE[0]}" == 'dimensions:' ]; then
				printf "Your resolution is %s, according to xdpyinfo.\n" "${LINE[1]}"
			fi
		done <<< "$(xdpyinfo)"
	}
fi

if [ "$MAN_COLORS" == "true" ] && type -fP man &> /dev/null; then
	man(){ #: Display man pages with a little color.
		# This was needed else it wouldn't work, unless absolute path.
		read ManExec <<< "$(type -fP man 2> /dev/null)"

		LESS_TERMCAP_mb=$'\e[01;31m'\
		LESS_TERMCAP_md=$'\e[01;31m'\
		LESS_TERMCAP_me=$'\e[0m'\
		LESS_TERMCAP_se=$'\e[0m'\
		LESS_TERMCAP_so=$'\e[01;44;33m'\
		LESS_TERMCAP_ue=$'\e[0m'\
		LESS_TERMCAP_us=$'\e[01;32m'\
		"$ManExec" "$@"
	}
fi

# An improvement of a code block found here:
# https://forums.linuxmint.com/viewtopic.php?f=47&t=263770&p=1432658#p1432285
suppress(){ #: Execute command ($1) and omit specified ($2) output.
	$1 |& while read -r; do
		[ "${REPLY//$2}" ] && printf '%b\n' "${REPLY//$2}"
	done

	return ${PIPESTATUS[0]}
}

# Search for & output files not found which were installed with a given package.
if type -fP dpkg-query &> /dev/null; then
	missingpkgfiles(){ #: Check for missing files installed from a given package(s).
		while read X; do
			[ -e "$X" -a "$X" ] || printf '%s\n' "$X"
		done <<< "$(dpkg-query -L "$@")"

		unset X
	}

	getpkgvers(){ #: Fetch a package and version list for Debian package building.
		dpkg-query -Wf '${Package} (${Version}), ' "$@" | sed -r 's/,{1}\s+$/\n/'
	}
fi

# The ago function is a handy way to output some of the apt-get's -o options.
if type -fP apt-get zcat &> /dev/null; then
	ago(){ #: List out various apt-get options for the -o flag.
		while read F1 _; do
			case $F1 in
				*::*)
					New=${F1//[&,.]}

					[ "$New" == "$Old" ] && continue
					printf '%s\n' "$New"

					Old=$New ;;
			esac
		done <<< "$(zcat /usr/share/man/man8/apt-get.8.gz)"

		unset New Old F1 _
	}
fi

# Search the given path(s) for file types of TYPE. Ignores filename extension.
if type -fP mimetype &> /dev/null; then
	sif(){ #: Search given path(s) for files of a specified type.
		[ $# -eq 0 ] && printf 'Usage: sif [Type] [FILE_1 [FILE_2 ...]]\n' 1>&2

		Type=$1
		shift

		for CurFile in "$@"; {
			while read -a X; do
				for I in "${X[@]}"; {
					case $I in
						"$Type") printf '%s\n' "$CurFile" ;;
					esac
				}
			done <<< "$(mimetype -bd "$CurFile")"
		}

		unset Type CurFile X I
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
		while IFS=':' read -a X; do
			if [ "$1" == "--nosys" ]; then
				#TODO: Make this omit system ones by testing for the shell used.
				if [[ ${X[5]/\/home\/syslog} == /home/* ]]; then
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

# Two possibly pointless functions to single- or double-quote a string of text.
squo(){ #: Surround ($@) text in single quotion marks.
	printf "'%s'\n\" \"\$*"
}

dquo(){ #: Surround ($@) text in double quotation marks.
	printf "\"%s\"\n" "$*"
}

# My preferred links2 settings. Also allows you to quickly search with DDG.
if type -fP links2 &> /dev/null; then
	l2(){ #: A tweaked links2 experience, opening with DuckDuckGo.
		links2 -http.do-not-track 1 -html-tables 1\
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
if type -fP mv &> /dev/null; then
	brn(){ #: Batch-rename a bunch of files or directories.
		printf "NOTE: To match directories instead, use -d|--directories OPTs.\n"

		while [ "$1" ]; do
			case $1 in
				--directories|-d)
					UseDirs='true' ;;
				'')
					;;
				*)
					printf "ERROR: Incorrect argument(s) specified." ;;
			esac
			shift
		done

		declare -i NUM=0
		for CurFile in *; {
			if { ! [ "$UseDirs" == "true" ] && [ -f "$CurFile" ]; }\
			|| { [ "$UseDirs" == "true" ] && [ -d "$CurFile" ]; }; then
				NUM+=1
				printf "\e[2;31mCurFile:\e[0m %s\n" "$CurFile"

				read -ep " >> "
				if [ "$REPLY" ]; then
					if mv "$CurFile" "$REPLY" 2> /dev/null; then
						printf "\e[2;32mItem #%d successfully renamed.\e[0m\n" $NUM
					else
						printf "\e[2;31mUnable to rename item #%d.\e[0m\n" $NUM
					fi
				fi
			fi
		}
	}
fi

if type -fP espeak &> /dev/null; then
	sayit(){ #: Say something with espeak; good for quick alerts.
		espeak -v en-scottish -g 5 -p 13 -s 0.7 "$*"
	}

	readit(){ #: Read a text file with espeak.
		{ [ -f "$*" ] && [ -r "$*" ]; } || return 1
		espeak -v en-scottish -g 5 -p 13 -s 0.7 < "$*"
	}
fi
