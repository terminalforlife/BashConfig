#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_functions
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_functions
# Started On        - Wed 24 Jan 00:16:36 GMT 2018
# Last Change       - Fri 11 Aug 00:01:05 BST 2023
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------

Err(){
	printf '\e[91mErr\e[0m: %s\n' "$1" 1>&2
}

AskYN() {
	while :; do
		read -p "$1 (Y/N) "
		case ${REPLY,,} in
			y|yes)
				return 0 ;;
			n|no)
				return 1 ;;
			'')
				Err 'Response required -- try again.' ;;
			*)
				Err 'Invalid response -- try again.' ;;
		esac
	done
}

overview() {
	if (( $? > 1 )); then
		printf 'Usage: %s [DIR] \n' "${FUNCNAME[0]}" 1>&2
		return 1
	fi

	du -h --max-depth=1 "${1:-./}" | sed -r '
		$d; s/^([.0-9]+[KMGTPEZY]\t)\.\//\1/
	' | sort -hr | column
}

systemctl() {
	/bin/systemctl --no-pager -l "$@"
}

remember() {
	Len=${#1}
	if (( Len <= 80 )); then
		printf '%s\n' "$1" > ~/.reminder
	else
		Err "String length of $Len exceeds limit of 80."
		return 1
	fi
}

csi3(){ /usr/local/bin/csi3 -f ~/.config/i3/binds "$@"; }

ssh(){ /usr/bin/ssh -q "$@"; }

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

uplinks() {
	if ! cd "$HOME"/GitHub/terminalforlife/Personal; then
		Err "Failed to browse to 'Personal' GitHub repositories."
		return 1
	fi

	local File
	for File in {ShellProjects,BashConfig,i3Config,VimConfig}/devutils/links.sh; {
		if ! [[ -f $File ]]; then
			Err "File '$File' not found."
			continue
		elif ! [[ -r $File ]]; then
			Err "File '$File' unreadable."
			continue
		fi

		sh "$File"
	}

	cd - 1> /dev/null
}

bat() {
	local File='/sys/class/power_supply/BAT1/capacity'
	if ! [[ -f $File ]]; then
		Err "File '$File' not found."
		return 1
	elif ! [[ -f $File ]]; then
		Err "File '$File' unreadable."
		return 1
	fi

	read < /sys/class/power_supply/BAT1/capacity
	printf 'Battery is at %d%% capacity.\n' "$REPLY"
}

fixmodes() {
	while read -r; do
		printf '%b\n' "$REPLY"
	done <<-EOF
		\e[91mWARNING\e[0m: You're about to irreversably \e[3mrecursively\e[0m change all files and
		         directories in the CWD, \e[3mexcept\e[0m '~/GitHub' and '~/.steam', to
		         \e[93m600\e[0m and \e[93m700\e[0m, respectively. Ownership will \e[3mnot\e[0m be effected.

	EOF

	if AskYN 'Are you sure?'; then
		find -xdev -not -path "$HOME/GitHub/*" -not -path "$HOME/.steam"\
			\( -type f -exec chmod 600 {} \+ -o -type d -exec chmod 700 {} \+ \)
	fi
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
			printf 'Err: No video clips provided.\n' 1>&2
			return 1
		fi
	}

	overlay() {
		if (( $# == 1 )); then
			ffmpeg -i "$1" -i "$HOME/Pictures/TFL/Stream Overlay.png"\
				-filter_complex '[0:v][1:v]overlay' -c:a copy overlay.mp4
		else
			printf 'Err: One video clip required.\n' 1>&2
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
	get() { wget -qc -U 'Mozilla/5.0' --show-progress "$@"; }

	ffget() {
		(
			cd "$HOME"/Downloads

			local URL='https://download.mozilla.org/?product='
			URL+='firefox-latest-ssl&os=linux64&lang=en-GB'
			get -O 'firefox.tar.bz2' "$URL"
		)
	}
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
	branch() { git branch "$@"; }
	checkout() { git checkout "$@"; }
	clone() { git clone "$@"; }
	commit() { git commit "$@"; }
	diff() { git diff "$@"; }
	merge() { git merge "$@"; }
	pull() { git pull "$@"; }

	push() {
		if ! git rev-parse --is-inside-work-tree &> /dev/null; then
			Err 'Not in a Git repository.'
			return 1
		fi

		# Because I have a habit of habitually pushing -- it's bad, I know.
		printf '\e[91mWARNING\e[0m: This will make these changes permanent!\n'
		while :; do
			read -p '         Are you sure you want to push? [Y|N] '
			case ${REPLY,,} in
				y|yes)
					git push "$@"
					break ;;
				n|no)
					break ;;
				'')
					Err 'Response required -- try again.' ;;
				*)
					Err 'Response invalid -- try again.' ;;
			esac
		done
	}

	rebase() { git rebase "$@"; }
	stash() { git stash "$@"; }
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
		while [[ -n $1 ]]; do
			case $1 in
				-p|--playlist)
					ExtraOpts+=' --yes-playlist ' ;;
				-a|--audio)
					ExtraOpts+=' -x --audio-format mp3 ' ;;
				-*)
					Err 'Usage: ytdl [{-p|--playlist}|{-a|--audio}] URL'
					return 1 ;;
				*)
					break ;;
			esac
			shift
		done

		youtube-dl -ic --format best --no-call-home --console-title\
			-o '%(title)s.%(ext)s' $ExtraOpts "$@"
	}
fi

if type -P xclip &> /dev/null; then
	ccb() {
		printf '' | xclip -sel c
		printf '' | xclip
	}
fi

if type -P lsblk &> /dev/null; then
	lsblkid() {
		lsblk -o name,label,fstype,size,uuid,mountpoint --noheadings "$@"
	}

	lsblk() {
		/bin/lsblk -o name,label,fstype,size,mountpoint --noheadings "$@"
	}
fi

sd() { cd /media/"$USER"; }
ghtflp() { cd "$HOME"/GitHub/terminalforlife/Personal; }
ghtflf() { cd "$HOME"/GitHub/terminalforlife/Forks; }

if type -P mplayer &> /dev/null; then
	mpa() { mplayer -really-quiet -volume 100 -nogui -nolirc -vo null "$@"; }
	mpv() { mplayer -really-quiet -volume 100 -vo x11 -zoom -nolirc "$@"; }
elif type -P mpv &> /dev/null; then
	mpa() { mpv --really-quiet --no-video "$@"; }
	mpv() { /usr/bin/mpv --really-quiet "$@"; }
fi

if type -P mplay mocp &> /dev/null; then
	mplay() { /usr/local/bin/mplay "$HOME"/Music "$@"; }
fi

thumbnail() {
	local File="$HOME/GitHub/terminalforlife/Personal/ChannelFiles"
	File+='/Miscellaneous Scripts/thumbnail-generator.sh'

	bash "$File" "$@"
}

if [[ -f $HOME/Documents/TT/shotmngr.sh ]]; then
	sm() {
		if ! [[ -r $HOME/Documents/TT/shotmngr.sh ]]; then
			Err "File '$HOME/Documents/TT/shotmngr.sh' unreadable."
			return 1
		fi

		bash "$HOME"/Documents/TT/shotmngr.sh "$@"
	}
fi

acs() {
	{
		apt-cache search "$1" | grep "$1" | sort -k 1
	} 2> /dev/null
}

sc() { awk -SP "BEGIN {print($*)}" 2> /dev/null; }

builtins() {
	if ! compgen -b | column 2>&-; then
		# Alternative method, if the above fails.
		while read -r; do
			printf '%s\n' "${REPLY/* }"
		done <<< "$(enable -a)" | column
	fi
}

getpkgvers() {
	dpkg-query -Wf '${Package} (${Version}), ' "$@" |
		sed -r 's/,{1}\s+$/\n/; s/\(/\(>= /g; s/ubuntu[0-9].[0-9]\)/\)/g'
}

l2() {
	links2 -http.do-not-track 1 -html-tables 1 -html-numbered-links 1\
		http://duckduckgo.com/?q="$*"
}

gp() {
	local URL="http://gtk2-perl.sourceforge.net/doc/pod/Gtk2/$1.html"

	case $1 in
		*\ *|'')
			printf 'Err: Invalid reference page provided.\n' 1>&2
			return 1 ;;
		*)
			if ! wget -q --spider "$URL"; then
				printf 'Err: Provided reference page not found.\n' 1>&2
				return 1
			fi ;;
	esac

	links2 -dump -html-tables 1 -html-frames 1 -http.do-not-track 1 "$URL"\
		| awk 'NR>=3 {print($0)}' | /usr/bin/less -Fs
}

brn() {
	printf 'NOTE: To match directories instead, use -d|--directories OPTs.\n'

	local UseDirs
	while [[ -n $1 ]]; do
		case $1 in
			--directories|-d)
				UseDirs='true' ;;
			*)
				printf "Err: Incorrect argument(s) specified."
				return 1 ;;
		esac
		shift
	done

	local CurFile Nr
	for CurFile in *; {
		if ! [[ $UseDirs == true && -f $CurFile ]]\
		|| [[ $UseDirs == true && -d $CurFile ]]; then
			(( Nr++ ))
			printf "\e[2;31mCurFile:\e[0m %s\n" "$CurFile"

			read -ep " >> "

			[[ -n $REPLY ]] || continue
			if mv "$CurFile" "$REPLY" 2> /dev/null; then
				printf "\e[2;32mItem #%d successfully renamed.\e[0m\n" $Nr
			else
				printf "\e[2;31mUnable to rename item #%d.\e[0m\n" $Nr
			fi
		fi
	}
}

sayit() { espeak -v en-scottish -g 5 -p 13 -s 0.7 "$*"; }

bblist() {
	{
		printf '[list]\n'
		printf '[*] %s\n' "$@"
		printf '[/list]\n'
	} | xclip -i -selection clipboard
}

purgerc() {
	local File='/var/lib/dpkg/status'
	if ! [[ -f $File ]]; then
		Err "File '$File' not found."
		return 1
	elif ! [[ -r $File ]]; then
		Err "File '$File' unreadable."
		return 1
	fi

	local Packages Key Value Package Status
	while IFS=':' read Key Value; do
		case $Key in
			Package)
				Package=${Value# } ;;
			Status)
				Status=${Value# } ;;
			Architecture)
				if [[ $Status == deinstall\ ok\ config-files ]]; then
					Packages+=("$Package:${Value# }")
				fi ;;
		esac
	done < "$File"

	sudo apt-get purge "${Packages[@]}"
}

# Test BASH Versions. For testing scripts with BASH >= 3.0.
tbv() {
	local File=$1
	shift

	if ! [[ -f $File ]]; then
		Err "File '$File' not found."
		return 1
	elif ! [[ -r $File ]]; then
		Err "File '$File' unreadable."
		return 1
	else
		# Verify the shebang is actually pointing to BASH. Reduces the chance of
		# accidentally trying to run the wrong file a bazillion times.
		read <<< "$(file "$File")"
		local Str=''
		case ${REPLY#*: } in
			'Bourne-Again shell script, ASCII text executable')
				;;
			'Bourne-Again shell script, UTF-8 Unicode text executable')
				;;
			''|*)
				Err 'File not a BASH script.'
				return 1 ;;
		esac
	fi

	local Dir
	for Dir in "$HOME/BASH/"*; {
		[[ -d $Dir ]] || continue

		printf '\e[1;92m* \e[91m%s:\e[0m\n' "${Dir##*/}"
		"$Dir"/bash "$File" "$@"
	}
}

lperl() {
	local Dir="$HOME/PERL"
	if ! [[ -d $Dir ]]; then
		Err "Directory '$Dir' not found."
		return 1
	elif ! [[ -r $Dir ]]; then
		Err "Directory '$Dir' unreadable."
		return 1
	elif ! [[ -x $Dir ]]; then
		Err "Directory '$Dir' unexecutable."
		return 1
	else
		# Grab the last file, to get the latest version.
		for Dir in "$Dir"/*; { :; }

		local File="$Dir/perl"
		[[ -f $File && -x $File ]] && "$File" "$@"
	fi
}

exin() {
	if (( $# == 0 )); then
		Err 'Argument required.'
		return 1
	elif (( $# > 1 )); then
		Err 'Only one argument is valid.'
		return 1
	fi

	IFS=':' read -a Paths <<< "$PATH"

	while read; do
		[[ -f $REPLY ]] || continue

		for Path in "${Paths[@]}"; {
			if [[ ${REPLY%/*} == $Path ]]; then
				printf '%s\n' "$REPLY"
				continue 2
			fi
		}
	done <<< "$(dpkg -L "$1" 2>&-)"
}

ws2dot() {
	if (( $# == 0 )); then
		Err 'Argument(s) required.'
		return 1
	fi

	case $1 in
		-s|--simulate)
			local Sim='echo'
			shift ;;
	esac

	local File
	for File in "$@"; {
		[[ -f $File ]] || continue
		$Sim mv "$File" "${File// /.}"
	}
}

toppy() {
	if (( $# != 0 )); then
		Err 'No argument(s) required.'
		return 1
	fi

	local Data=() MaxLenPid=3 MaxLenProc=7\
		Proc Pages Comm PID Memory LenPID LenProc Unit

	for Proc in /proc/[[:digit:]]*; {
		[[ -d $Proc && -x $Proc ]] || continue
		[[ -f $Proc/statm && -r $Proc/statm ]] || continue
		[[ -f $Proc/comm && -r $Proc/comm ]] || continue

		read _ Pages _ < "$Proc"/statm
		read Comm < "$Proc"/comm

		PID=${Proc##*/}

		# Seems to be the same as RSS.
		(( Memory = Pages * 4096 ))

		LenPID=${#PID}
		LenProc=${#Comm}

		(( LenPID > MaxLenPID )) && MaxLenPID=$LenPID
		(( LenProc > MaxLenProc )) && MaxLenProc=$LenProc

		Data+=("$PID|$Comm|$Memory")
	}

	printf '%-*s  %-*s  %-s\n' $MaxLenPID 'PID'\
		$MaxLenProc 'PROCESS' 'MEMORY'

	Len=${#Data[@]}
	for (( Index = 1; Index < Len; Index++ )); {
		Cur=${Data[Index]}
		Pos=$Index

		while (( Pos > 0 && ${Data[Pos - 1]##*|} < ${Cur##*|} )); do
			Data[Pos--]=${Data[Pos - 1]}
		done

		Data[Pos]=$Cur
	}

	for Data in "${Data[@]:0:10}"; {
		IFS='|' read PID Proc Memory <<< "$Data"

		for Unit in b K M G T P E Z Y; {
			if (( Memory > 1024 )); then
				(( Memory /= 1024 ))
			else
				Memory="$Memory$Unit"

				break
			fi
		}

		printf "%-*d  %-*s  %-s\n" $MaxLenPID\
			$PID $MaxLenProc "$Proc" $Memory
	}
}

lscoreutils() {
	local ListFile='/var/lib/dpkg/info/coreutils.list'

	if (( $# > 0 )); then
		Err 'No Arguments required.'
		return 1
	elif ! [[ -f $ListFile ]]; then
		Err "File '$ListFile' not found."
		return 1
	elif ! [[ -r $ListFile ]]; then
		Err "File '$ListFile' unreadable."
		return 1
	fi

	local Index
	local Buffer=
	local Paths=()
	local Path="$PATH:"
	local Len=${#Path}
	for (( Index = 0; Index < Len; Index++ )); {
		Char=${Path:Index:1}
		if [[ $Char == : ]]; then
			Paths+=("$Buffer")
			Buffer=
		else
			Buffer+=$Char
		fi
	}

	local Utils=()
	while read; do
		[[ -f $REPLY ]] || continue

		for Path in "${Paths[@]}"; {
			if [[ ${REPLY%/*} == $Path ]]; then
				Utils+=("${REPLY##*/}")

				break
			fi
		}
	done < "$ListFile"

	Len=${#Utils[@]}
	for (( Index = 1; Index < Len; Index++ )); {
		Cur=${Utils[Index]}
		Pos=$Index

		while (( Pos > 0 )) && [[ ${Utils[Pos - 1]} > $Cur ]]; do
			Utils[Pos--]=${Utils[Pos - 1]}
		done

		Utils[Pos]=$Cur
	}

	printf '%s\n' "${Utils[@]}" | column
}

# Execute a shell command but with a wrapper which notifies upon completion.
# If the command succeeds, a normal notification is sent, otherwise a critical
# one is sent. This function works with sudo(8), provided you include it as
# part of the arguments, as normal.
if type -P notify-send &> /dev/null; then
	notify() {
		Args=("$@")
		ArgsOut=("${Args[@]:1}")

		"${Args[@]}"

		local Status=$?
		local Urgency='normal'
		if (( $? > 0 )); then
			Urgency='critical'
		fi

		notify-send --urgency="${Urgency:-normal}"\
			"Task Finished [$Status]" "notify(): ${ArgsOut[*]:0:26}"
	}
fi

if type -P convert &> /dev/null; then
	lmsf() {
		if (( $# != 2 )); then
			printf 'Usage: %s INPUT OUTPUT\n' "${FUNCNAME[0]}" 1>&2
			return 1
		fi

		case ${1##*.} in
			jpg|jpeg)
				convert "$1" -resize 40% "$2" ;;
			png)
				convert "$1" -resize 40% "${2.???}.jpg" ;;
			'')
				printf 'Err: Filename extension for INPUT not found.\n' 1>&2
				return 1 ;;
			*)
				printf 'Err: Unsupported INPUT image file type.\n' 1>&2
				return 1 ;;
		esac
	}

	matryoshka() {
		if (( $# == 0 )); then
			printf 'Usage: %s FILE [INT [INT] ...]\n' "${FUNCNAME[0]}" 1>&2
			return 1
		fi

		File=$1
		shift

		local Size
		for Size in ${@:-16 24 32 64}; {
			NewFile="${File%.*}"_${Size}x$Size."${File#*.}"
			if ! [[ -f $NewFile ]]; then
				convert -resize ${Size}x$Size "$File" "$NewFile"
			else
				Err "File '$NewFile' exists -- skipping."
			fi
		}
	}
fi

if type -P snotes &> /dev/null; then
	snotes() { /usr/local/bin/snotes -n "$@"; }
fi

if type -P python &> /dev/null; then
	starfield() { countdown 1693958400; }
fi

if type -P ncal &> /dev/null; then
	cal() { ncal -MbA 1 "$@"; }
fi
