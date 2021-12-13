#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_functions
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Mon 13 Dec 12:57:57 GMT 2021
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------

Err(){
	printf '\e[91mErr\e[0m: %s\n' "$1" 1>&2
	return 1
}

rm() { /bin/rm -v --preserve-root "$@"; }
chown() { /bin/chown -v --preserve-root "$@"; }
chmod() { /bin/chmod -v --preserve-root "$@"; }
mv() { /bin/mv -vn "$@"; }
mkdir() { /bin/mkdir -v "$@"; }
cp() { /bin/cp -vn "$@"; }
ln() { /bin/ln -v "$@"; }
rmdir() { /bin/rmdir -v "$@"; }

ls() {
	/bin/ls --quoting-style=literal -pq --time-style=iso --color=auto\
		--group-directories-first --show-control-chars "$@"
}

grep() { /bin/grep -sI --color=auto "$@"; }

md5sum() { /usr/bin/md5sum --ignore-missing --quiet -c; }

if [ -f "$HOME"/Documents/TT/bin/sweep ]; then
	hsh() {
		if ! [ -r "$HOME"/Documents/TT/bin/sweep ]; then
			Err "File '$HOME/Documents/TT/bin/sweep' unreadable."
			return 1
		fi

		bash "$HOME"/Documents/TT/bin/sweep
	}
fi

if type -P espeak &> /dev/null; then
	countdown() {
		if ! [[ $1 =~ ^[0-9]+$ ]]; then
			Err 'Numeric argument required.'
			return 1
		elif (( $1 > 100 )); then
			Err 'A valid number is between 1 and 100.'
			return 1
		fi

		local Count
		for (( Count = ${1:-10}; Count >= 0; Count-- )); {
			espeak -a 100 -s 200 -p 0 "$Count" &> /dev/null &
			sleep 1
		}
	}
fi

uplinks() {
	if ! cd "$HOME"/GitHub/terminalforlife/Personal; then
		Err "Failed to browse to 'Personal' GitHub repositories."
		return 1
	fi

	local File
	for File in {Extra,BashConfig,i3Config,VimConfig}/devutils/links.sh; {
		if ! [ -f "$File" ]; then
			Err "File '$File' not found."
			continue
		elif ! [ -r "$File" ]; then
			Err "File '$File' unreadable."
			continue
		fi

		sh "$File"
	}

	cd - 1> /dev/null
}

if [ -f /sys/class/power_supply/BAT1/capacity ]; then
	bat() {
		if ! [ -r /sys/class/power_supply/BAT1/capacity ]; then
			Err "File '/sys/class/power_supply/BAT1/capacity' unreadable."
			return 1
		fi

		read < /sys/class/power_supply/BAT1/capacity
		printf 'Battery is at %d%% capacity.\n' "$REPLY"
	}
fi

fixmodes() {
	while read -r; do
		printf '%b\n' "$REPLY"
	done <<-EOF
		\e[91mWARNING\e[0m: You're about to irreversably \e[3mrecursively\e[0m change all files and
		         directories in the CWD, \e[3mexcept\e[0m '~/GitHub' and '~/.steam', to
		         \e[93m600\e[0m and \e[93m700\e[0m, respectively. Ownership will \e[3mnot\e[0m be effected.

	EOF

	read -p 'Are you sure? (Y/N) '
	case $REPLY in
		[Yy]|[Yy][Ee][Ss])
			find -xdev -not -path "$HOME/GitHub/*" -not -path "$HOME/.steam"\
				\( -type f -exec chmod 600 {} \+ -o -type d -exec chmod 700 {} \+ \) ;;
		[Nn]|[Nn][Oo])
			printf 'Nothing to do -- quitting.\n' ;;
		''|*)
			Err 'Invalid response -- quitting.'
			return 1 ;;
	esac
}

if type -P ffmpeg &> /dev/null; then
	ffmpeg() { /usr/bin/ffmpeg -v 0 -stats "$@"; }

	clips() {
		if ! (( $# == 0 || $# == 1 )); then
			printf "file '%s'\n" "$@" > flist
			ffmpeg -f concat -i flist -safe 0 -codec:a\
				copy -codec:v copy output.mp4

			rm flist
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
fi

if type -P feh &> /dev/null; then
	img() {
		feh --fullscreen --hide-pointer --draw-filename --no-menus 2> /dev/null
	}
fi

if type -P wget &> /dev/null; then
	get() { wget -qc --show-progress "$@"; }
fi

alert() {
	for I in {1..3}; {
		sleep 0.03s
		printf "\a\e[?5h"
		sleep 0.03s
		printf "\a\e[?5l"
	}
}

dwatch() {
	watch -n 0.1 -t 'ls -SsCphq --color=auto --group-directories-first'
}

if type -P git &> /dev/null; then
	add() { git add "$@"; }
	checkout() { git checkout "$@"; }
	pull() { git pull "$@"; }
	commit() { git commit "$@"; }
	merge() { git merge "$@"; }
	branch() { git branch "$@"; }
	push() { git push "$@"; }
	diff() { git diff "$@"; }
	status() { git status -s "$@"; }

	show() {
		git --no-pager show --pretty --pretty=format:'%h: %s' "$@"
	}

	toplevel() {
		cd "$(git rev-parse --show-toplevel)"
	}

	log() {
		git --no-pager log --reverse --pretty=format:'%h: "%s"' "$@"
		printf '\n'
	}
fi

if type -P youtube-dl &> /dev/null; then
	ytdl() {
		local ExtraOpts
		while [ -n "$1" ]; do
			case $1 in
				-p|--playlist)
					ExtraOpts+='--yes-playlist ' ;;
				-a|--audio)
					ExtraOpts+='-x --audio-format mp3 ' ;;
			esac
			shift
		done

		youtube-dl -ic --format best --no-call-home --console-title\
			-o '%(title)s.%(ext)s' $ExtraOpts "$@"
	}
fi

if type -P xclip &> /dev/null; then
	ccb() {
		printf '' | xclip -i -selection clipboard
		printf '' | xclip -i
	}
fi

lsblkid() { lsblk -o name,label,fstype,size,uuid --noheadings "$@"; }

sd() { cd /media/"$USER"; }
ghtflp() { cd "$HOME"/GitHub/terminalforlife/Personal; }
ghtflf() { cd "$HOME"/GitHub/terminalforlife/Forks; }
tt() { cd "$HOME"/Documents/TT; }
i3a() { cd "$HOME"/.i3a; }

if type -P mplayer &> /dev/null; then
	mpa() {
		mplayer -volume 100 -nogui -nolirc -vo null -really-quiet "$@" &> /dev/null
	}

	mpv() {
		mplayer -volume 100 -vo x11 -nolirc -really-quiet "$@" &> /dev/null
	}
fi

if type -P mplay mocp &> /dev/null; then
	mplay() { mplay /media/"$USER"/Main\ Data/Linux\ Generals/Music; }
fi

thumbnail() {
	local File="$HOME/GitHub/terminalforlife/Personal/ChannelFiles"
	File+='/Miscellaneous Scripts/thumbnail-generator.sh'

	sh "$File"
}

if [ -f "$HOME"/Documents/TT/shotmngr.sh ]; then
	sm() {
		if ! [ -r "$HOME"/Documents/TT/shotmngr.sh ]; then
			Err "File '$HOME/Documents/TT/shotmngr.sh' unreadable."
			return 1
		fi

		bash "$HOME"/Documents/TT/shotmngr.sh
	}
fi

if [ -f "$HOME"/Documents/TT/bin/poks ]; then
	poks() {
		if ! [ -r "$HOME"/Documents/TT/bin/poks ]; then
			Err "File '$HOME/Documents/TT/bin/poks' unreadable."
			return 1
		fi

		sh "$HOME"/Documents/TT/bin/poks
	}
fi

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
		'')
			printf 'ERROR: Filename extension for INPUT not found.\n' 1>&2
			return 1 ;;
		*)
			printf 'ERROR: Unsupported INPUT image file type.\n' 1>&2
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

bblist() {
	{
		printf '[list]\n'
		printf '[*] %s\n' "$@"
		printf '[/list]\n'
	} | xclip -i -selection clipboard
}
