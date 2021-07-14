#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_functions
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Wed 14 Jul 17:37:02 BST 2021
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# IMPORTANT: If you use `lad`, you need to read the contents of `lad --help`
#            before making any changes to this file, or risk breaking it's
#            functionality.
#------------------------------------------------------------------------------

qse(){ #: Search Debian packages with APT, properly.
	{ apt-cache search ' ' | grep "$*" | sort -k 1; } 2> /dev/null
}

lmsf() {
	if [ $# -ne 2 ]; then
		printf 'Usage: %s [INPUT] [OUTPUT]\n' "${FUNCNAME[0]}" 1>&2
		return 1
	fi

	case ${1##*.} in
		jpg|jpeg)
			convert "$1" -resize 40% "$2" ;;
		png)
			convert "$1" -resize 40% "${2.???}.jpg" ;;
		*)
			printf 'ERROR: Unsupported INPUT image filetype.\n' 1>&2
			return 1 ;;
		'')
			printf 'ERROR: Filename extension for INPUT not found.\n' 1>&2
			return 1 ;;
	esac
}

bins(){ #: A lite version of what lsbins(1) achieves.
	if [ $# -gt 1 ] || [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
		printf 'Usage: %s [REGEX]\n' "${FUNCNAME[0]}" 1>&2
		return 1
	fi

	for Dir in ${PATH//:/ }; {
		for File in "$Dir"/*; {
			if [ -f "$File" ] && [ -x "$File" ]; then
				Basename=${File##*/}
				if [ -z "$1" ]; then
					printf '%s\n' "$Basename"
				elif [[ $Basename =~ $1 ]]; then
					printf '%s\n' "$Basename"
				fi
			fi
		}
	} | sort -u

	unset File Dir Exes
}

pulloo(){ #: Personal function to `pull` in all my own repositories.
	for Dir in "$HOME"/GitHub/terminalforlife/Personal/*; {
		git -C "$Dir" pull | grep --color=never -vF 'Already up-to-date'
	}
}

# Function contains code I've written for and sent a PR to:
#
#   https://github.com/AlexChaplinBraz/dmenu-scripts
#
dman(){ #: Use Dmenu to interactively look for and display a man page.
	local Chosen=$(
		man -k . 2> /dev/null | while read Pkg Group _ Desc; do
			# The `#- ` bit fixes entries with botched short descriptions.
			printf '%50s - %s\n' "$Pkg $Group" "${Desc#- }"
		done | dmenu -i -l 30 -fn 'Ubuntu Mono':style=Bold:size=12\
			-nb \#000000 -nf \#ffffff -sb \#550000 -sf \#ffffff
			# Dmenu is using my customizations from i3Config here.
	)

	local FieldCount=0
	local Field Pkg Group
	for Field in $Chosen; do
		FieldCount=$((FieldCount + 1))

		case $FieldCount in
			1) Pkg=$Field ;;
			2) Group=${Field%)} ;;
			*) break ;;
		esac
	done

	man "${Group#(}" "$Pkg" 2> /dev/null
}

touched(){ #: Tell the user how many commits have touched the given file(s).
	for File in "$@"; {
		if ! git rev-parse --is-inside-work-tree &> /dev/null; then
			printf 'ERROR: Not inside a Git repository.\n' 1>&2
			return 1
		elif ! [ -e "$File" ]; then
			printf "ERROR: '%s' doesn't exist.\n" "$File" 1>&2
			return 1
		fi

		if [ -d "$File" ]; then
			local FiDi='Directory'
		elif [ -f "$File" ]; then
			local FiDi='File'
		fi

		readarray Lines <<< "$(git rev-list HEAD "$File")"
		printf "%s '%s' has been touched by %d commit(s).\n"\
			"$FiDi" "$File" ${#Lines[@]}

		unset File
	}
}

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

gitgrep(){ #: Execute a configured grep command in git context.
	grep -sIr --exclude-dir='.git' --exclude='LICENSE' --exclude='README.md'\
		--exclude={.bash{_{aliases,functions,logout,profile},rc},{,.}inputrc,inputrc}\
		--exclude='*.'{mp3,jpg,ogg,png,deb,xml} --color=auto "$@"
}

noab(){ #: No absolutes for executables found in PATH directories and the given file.
	if ! [ -f "$1" -a -r "$1" -a -w "$1" ]; then
		printf "ERROR: File missing or insufficient permissions.\n"
		return 1
	fi

	printf "WARNING: The file will be irreversibly changed!\n"
	read -n 1 -e -p "Press any key to continue, or Ctrl+C to cancel... "

	P=(`grep -Eo "(${PATH//://|})[a-Z0-9_-]+" "$1" 2> /dev/null | uniq 2> /dev/null`)
	for F in ${P[@]}; { sed -i "s|$F |${F##*/} |g" "$1" 2> /dev/null; }
}

# Inspired by 'paperbenni' on GitHub.
if type -P sha256sum &> /dev/null || type -P md5sum &> /dev/null; then
	hash() { #: Fetch and compare the sha256 sums of two or more files.
		local I=`awk '{!A[$1]++} END{print(NR)}' <(sha256sum "$@" 2> /dev/null)`
		if [ $I -eq 0 ]; then
			printf "Usage: hash [FILE_1] [FILE_2] ...\n" >&2
			return 2
		elif [ $I -eq 1 ]; then
			return 1
		fi
	}
elif type -P md5sum &> /dev/null; then
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

sc(){ #: Perform mathematical calculations via AWK.
	awk -SP "BEGIN {print($*)}" 2> /dev/null
}

mpvi(){ #: In i3-wm, play a video inside the active window.
	tput smcup
	tput clear

	WID=`xprop -root _NET_ACTIVE_WINDOW | cut -d "#" -f 2`
	mplayer -msglevel "all=-1" -nolirc -wid "$WID" "$@" &> /dev/null

	# Addresses bug. The window will otherwise fill with last frame.
	wait; tput rmcup

	unset WID
}

builtins(){ #: Display a columnized list of bash builtins.
	while read -r; do
		printf "%s\n" "${REPLY/* }"
	done <<< "$(enable -a)" | column
}

dpi(){ #: Display the current DPI setting.
	while read -a X; do
		if [ "${X[0]}" == "resolution:" ]; then
			printf "%s\n" "${X[1]/*x}"
		fi
	done <<< "$(xdpyinfo)"
}

fans(){ #: Show the available system fan speeds using sensors.
	while read; do
		if [[ $REPLY == *[Ff][Aa][Nn]*RPM ]]; then
			printf "%s\n" "$REPLY"
		fi
	done <<< "$(sensors)"
}

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

if type -P xwininfo &> /dev/null; then
	getres(){ #: Two viable methods for fetching the display resolution.
		while read -a LINE; do
			if [ "${LINE[0]}" == '-geometry' ]; then
				printf "Your resolution is %s, according to xwininfo.\n" "${LINE[1]%+*+*}"
			fi
		done <<< "$(xwininfo -root)"
	}
elif type -P xdpyinfo &> /dev/null; then
	getres(){
		while read -a LINE; do
			if [ "${LINE[0]}" == 'dimensions:' ]; then
				printf "Your resolution is %s, according to xdpyinfo.\n" "${LINE[1]}"
			fi
		done <<< "$(xdpyinfo)"
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

getpkgvers(){ #: Fetch a package and version list for Debian package building.
	dpkg-query -Wf '${Package} (${Version}), ' "$@" |
		sed -r 's/,{1}\s+$/\n/; s/\(/\(>= /g; s/ubuntu[0-9].[0-9]\)/\)/g'
}

inout(){ #: Display total network data transfer this session.
	local X
	while read -a X; do
		if [ "${X[0]}" == "$1:" ]; then
			declare -i IN=${X[1]}
			declare -i OUT=${X[9]}
			break
		fi
	done < /proc/net/dev

	printf "IN:  %'14dK\nOUT: %'14dK\n" "$((IN/1024))" "$((OUT/1024))"
}

lsusers(){ #: List users on the system, according to '/etc/passwd'.
	printf "%-20s %-7s %-7s %-25s %s\n" "USERNAME" "UID" "GID" "HOME" "SHELL"

	local X
	while IFS=':' read -a X; do
		if [ "$1" == "--nosys" ]; then
			# It's possible some users might show up if they mistakenly
			# were given a HOME, but '--nosys' should otherwise work.
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

l2(){ #: A tweaked links2 experience, allowing for quick DuckDuckGo searches.
	links2 -http.do-not-track 1 -html-tables 1 -html-numbered-links 1\
		http://duckduckgo.com/?q="$*"
}

gp(){ #: Dump formatted HTML output from a Perl Gtk2 reference page.
	URL="http://gtk2-perl.sourceforge.net/doc/pod/Gtk2/$1.html"

	case $1 in
		*\ *|'')
			printf 'ERROR: Invalid reference page provided.\n' 1>&2
			return 1 ;;
		*)
			if ! wget -q --spider "$URL"; then
				printf 'ERROR: Provided reference page not found.\n' 1>&2
				return 1
			fi ;;
	esac

	links2 -dump -html-tables 1 -html-frames 1\
		-http.do-not-track 1 "$URL"\
		| awk 'NR>=3 {print($0)}' | \less -Fs

	unset URL
}

# Prompt to somewhat programmatically rename each file within the current
# directory. To skip one, simply submit an empty string. Output is fairly
# quiet. Does not work recursively, nor will it try to name anything but files.
# Uses color in output to make it quick and easy to read; may not work on all
# terminals. The changes are made the moment you press Enter, so be mindful!
# Ctrl + C to cancel. Use OPT -d or --directories to instead match those.
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

sayit(){ #: Say something with espeak; good for quick alerts.
	espeak -v en-scottish -g 5 -p 13 -s 0.7 "$*"
}

readit(){ #: Read a text file with espeak.
	{ [ -f "$*" ] && [ -r "$*" ]; } || return 1
	espeak -v en-scottish -g 5 -p 13 -s 0.7 < "$*"
}

clips(){ #: Concatenate video clips & add overlay.
	if ! (( $# == 0 || $# == 1 )); then
		printf "file '%s'\n" "$@" > flist
		ffmpeg -f concat -i flist -safe 0 -codec:a\
			copy -codec:v copy output.mp4

		\rm flist
	else
		printf 'ERROR: No video clips provided.\n' 1>&2
		return 1
	fi
}


overlay(){ #: Add the TFL overlay to a video file.
	if (( $# == 1 )); then
		ffmpeg -i "$1" -i "$HOME/Pictures/TFL/Stream Overlay.png"\
			-filter_complex '[0:v][1:v]overlay' -c:a copy overlay.mp4
	else
		printf 'ERROR: One video clip required.\n' 1>&2
		return 1
	fi
}

bblist(){
	perl -e '
		print("[list]\n");
		print("[*] $_\n") foreach sort({$a cmp $b} @ARGV);
		print("[/list]\n")
	' "$@" | xclip -i -selection clipboard
}

tops(){
	du --max-depth=1 . | perl -ne '
		BEGIN {
			our %Files;
			our $SizeLenMax = 0;
		}

		my @Line = split(" ", $_);

		my $Size = sprintf("%0.2fM", $Line[0] / 1024);
		my $SizeLen = length($Size);
		$SizeLen > $SizeLenMax and $SizeLenMax = $SizeLen;

		my $Path = join(" ", @Line[1,]) =~ s/^\.\///r;
		$Files{$Size} = $Path unless $Path eq ".";

		END {
			my $Count = 0;
			foreach (sort({$b <=> $a} keys(%Files))) {
				$Count++;
				$Count > 10 and last();

				$Files{$_} eq $ENV{"HOME"} and next();

				printf("%*s %s\n", $SizeLenMax, $_, $Files{$_})
			}
		}
	'
}
