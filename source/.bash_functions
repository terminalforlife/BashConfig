#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_functions
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Mon 13 Dec 08:36:37 GMT 2021
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------

acs() {
	{
		apt-cache search "$1" | grep "$1" | sort -k 1
	} 2> /dev/null
}

lmsf() {
	if [ $# -ne 2 ]; then
		printf 'Usage: %s <INPUT> <OUTPUT>\n' "${FUNCNAME[0]}" 1>&2
		return 1
	fi

	case ${1##*.} in
		jpg|jpeg)
			convert "$1" -resize 40% "$2" ;;
		png)
			convert "$1" -resize 40% "${2.???}.jpg" ;;
		*)
			printf 'ERROR: Unsupported INPUT image file type.\n' 1>&2
			return 1 ;;
		'')
			printf 'ERROR: Filename extension for INPUT not found.\n' 1>&2
			return 1 ;;
	esac
}

touched() {
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

sc() {
	awk -SP "BEGIN {print($*)}" 2> /dev/null
}

builtins() {
	while read -r; do
		printf "%s\n" "${REPLY/* }"
	done <<< "$(enable -a)" | column
}

getpkgvers() {
	dpkg-query -Wf '${Package} (${Version}), ' "$@" |
		sed -r 's/,{1}\s+$/\n/; s/\(/\(>= /g; s/ubuntu[0-9].[0-9]\)/\)/g'
}

inout() {
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

l2() {
	links2 -http.do-not-track 1 -html-tables 1 -html-numbered-links 1\
		http://duckduckgo.com/?q="$*"
}

gp() {
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

	links2 -dump -html-tables 1 -html-frames 1 -http.do-not-track 1 "$URL"\
		| awk 'NR>=3 {print($0)}' | \less -Fs

	unset URL
}

brn() {
	printf 'NOTE: To match directories instead, use -d|--directories OPTs.\n'

	while [ -n "$1" ]; do
		case $1 in
			--directories|-d)
				UseDirs='true' ;;
			*)
				printf "ERROR: Incorrect argument(s) specified." ;;
		esac
		shift
	done

	for CurFile in *; {
		if { ! [ "$UseDirs" == "true" ] && [ -f "$CurFile" ]; }\
		|| { [ "$UseDirs" == "true" ] && [ -d "$CurFile" ]; }; then
			(( Nr++ ))
			printf "\e[2;31mCurFile:\e[0m %s\n" "$CurFile"

			read -ep " >> "

			[ -n "$REPLY" ] || continue
			if mv "$CurFile" "$REPLY" 2> /dev/null; then
				printf "\e[2;32mItem #%d successfully renamed.\e[0m\n" $Nr
			else
				printf "\e[2;31mUnable to rename item #%d.\e[0m\n" $Nr
			fi
		fi
	}
}

sayit() {
	espeak -v en-scottish -g 5 -p 13 -s 0.7 "$*"
}

clips() {
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

overlay() {
	if (( $# == 1 )); then
		ffmpeg -i "$1" -i "$HOME/Pictures/TFL/Stream Overlay.png"\
			-filter_complex '[0:v][1:v]overlay' -c:a copy overlay.mp4
	else
		printf 'ERROR: One video clip required.\n' 1>&2
		return 1
	fi
}

bblist() {
	{
		printf '[list]\n'
		printf '[*] %s\n' "$@"
		printf '[/list]\n'
	} | xclip -i -selection clipboard
}
