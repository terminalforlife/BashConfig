#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Fri 27 Oct 23:27:04 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

# Just in-case.
[ -z "$BASH_VERSION" ] && return 1

# Nifty trick to allow aliases to work with sudo. This avoids needing sudo in these
# configuration files, since using sudo within a bash script/program is not great.
alias sudo="sudo "

# Handy alias to run before going off to bed, or before going out. I set this up
# pretty quickly just before I went to bed, so it'll probably be revised soon.
declare -i DEPCOUNT=0
for DEP in\
\
	/sbin/shutdown /bin/{sh,sync,sleep} /usr/bin/{clamscan,rkhunter}\
	/usr/sbin/{e4defrag,chkrootkit,unhide}
{
	[ -x "$DEP" ] && DEPCOUNT+=1

	# Only execute if all 3 dependencies are found.
	[ $DEPCOUNT -eq 10 ] && {
		BEFORE_GOING_TO_BED(){
			local SH_CMDS="/usr/bin/clamscan -riz /;\
				       /usr/sbin/e4defrag / 1> /dev/null;\
				       /usr/sbin/chkrootkit;\
				       /usr/bin/rkhunter -c --cronjob --report-warnings-only;\
				       /usr/sbin/unhide -m -d sys procall brute reverse"

			/bin/sh -c "$SH_CMDS"\
				&> $HOME/Desktop/b4bed_`printf '%(%F_%X)T'`.log

			/bin/sync
			/bin/sleep 10s
			/sbin/shutdown now
		}

		alias b4bed='BEFORE_GOING_TO_BED'
	}
}

# Quickly view all of your sd* storage device temperatures.
[ -x /usr/sbin/hddtemp ] && {
	alias temphdd='/usr/sbin/hddtemp /dev/sd{a..z} 2> /dev/null'
}

# Quickly download with wget, using some tider settings with -c.
[ -x /usr/bin/wget ] && {
	alias get='/usr/bin/wget -qc --show-progress'
}

# View the system boot log.
[ -f /var/log/boot.log ] && {
	alias bootlog='\
		while read -r; do
			printf "%s\n" "$REPLY"
		done < /var/log/boot.log
	'
}

# A simple dictionary lookup alias, similar to the look command.
{ [ -f /usr/share/dict/words ] && [ -r /usr/share/dict/words ]; } && {
	alias dict='\
		DICT_LOOKUP(){
			while read -r; do
				[[ "$REPLY" == *"$1"* ]] && echo "$REPLY"
			done < /usr/share/dict/words
		}

		DICT_LOOKUP\
	'
}

[ -x /usr/bin/newsbeuter ] && {
	# Load newsbeuter more quickly to get access to RSS feeds.
	alias news='\
		/usr/bin/newsbeuter -qr\
			-c "$HOME/.newsbeuter/cache.db"\
			-u "$HOME/.newsbeuter/urls"\
			-C "$HOME/.newsbeuter/newsbeuter.conf"
	'

	# Quickly edit RSS feed list.
	alias rss='/usr/bin/vim $HOME/.newsbeuter/urls'
}

# Watches a directory as its size and number files increase. Useful while you're
# downloading or making other sorts of changes to its contents, and want to watch.
{ [ -x /bin/ls ] && [ -x /usr/bin/watch ]; } && {
	alias dwatch='\
		/usr/bin/watch -n 0.1 "/bin/ls -SsCphq\
			--color=auto --group-directories-first"
	'
}

# Blast away all of the (global) configuration files of the previously uninstalled
# packages using dpkg to detect them and apt-get to purge them.
{ [ -x /usr/bin/apt-get ] && [ -x /usr/bin/dpkg ]; } && {
	#TODO - Incomplete and probably not yet functional, hence -s.
	alias rmrc='\
		local LIST=$(
			while read -ra REPLY; do
				[[ "${REPLY[0]}" == rc ]] && echo "${REPLY[1]}"
			done <<< "$(/usr/bin/dpkg -l 2> /dev/null)"
		)

		/usr/bin/apt-get -s purge $LIST
	'
}

# Fix all CWD file and directory permissions to match the safer 0077 umask.
[ -x /bin/chmod ] && {
	alias fixperms='\
		for FILE in ./*; {
			if [ -f "$FILE" ]; then
				chmod 600 "$FILE"
			elif [ -d "$FILE" ]; then
				chmod 700 "$FILE"
			fi
		}
	'
}

# Create or unmount a user-only RAM Disk (tmpfs, basically) of 512MB.
{ [ -x /bin/mount ] && [ -x /bin/umount ]; } && {
	RAMDISK="/media/$USER/RAMDisk_512M"

	alias rd='\
		/bin/mount -t tmpfs tmpfs\
			-o x-mount.mkdir=700,uid=1000,gid=1000,mode=700,nodev\
			-o noexec,nosuid,size=512M "$RAMDISK"
	'

	alias nord='\
		/bin/sh -c /bin/umount\ "$RAMDISK"\ \&\&\ /bin/rmdir\ "$RAMDISK"
	'
}

# Two possibly pointless functions to single- or double-quote a string of text.
alias squo="QUOTE(){ printf \"'%s'\n\" \"\$*\"; }; QUOTE"
alias dquo='QUOTE(){ printf "\"%s\"\n" "$*"; }; QUOTE'

# Show the fan speeds using sensors.
[ -x /usr/bin/sensors ] && {
	alias showfans='\
		while read; do
			[[ "$REPLY" == *[Ff][Aa][Nn]*RPM ]] && echo "$REPLY"
		done <<< "$(/usr/bin/sensors)"
	'
}

# Display a columnized list of bash builtins.
[ -x /usr/bin/column ] && {
	alias builtins='\
		while read -r
		do
			echo "${REPLY/* }"
		done <<< "$(enable -a)" | /usr/bin/column
	'
}

# Rip audio CDs with ease, then convert to ogg, name, and tag. Change the device
# as fits your needs, same with the formats used. Needs testing.
declare -i DEPCOUNT=0
for DEP in /usr/bin/{eject,kid3,ffmpeg,cdparanoia}; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	# Only execute if all 3 dependencies are found.
	[ $DEPCOUNT -eq 4 ] && {
		alias cdrip='\
			/usr/bin/cdparanoia -B 1- && {
				for FILE in *; {
					/usr/bin/ffmpeg -i "$FILE"\
						"${FILE%.wav}.ogg" &> /dev/null
				}
			}
		'
	}
}

# Enable a bunch of git aliases, if you have git installed.
{ [ -x /usr/bin/git ] && [ -x /bin/date ]; } && {
	GIT_LOG_ALIAS(){
		declare -i COUNT=0
		local RESULT=`/usr/bin/git log`

		[ "$RESULT" ] || return

		while read -r; do
			[[ "$REPLY" == Date:\ \ \ [A-Z][a-z][a-z]\ * ]] && {
				/bin/date -d "${REPLY:8:24}" +%F\ \(%X\)
				COUNT+=1
			}
		done <<< "$RESULT"

		echo "TOTAL:    $COUNT"

		unset COUNT REPLY
	}

	alias log="GIT_LOG_ALIAS"

	GIT_COMMIT_TOTALS(){
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
						printf "%-7d  %s\n"\
							"${REPLY[1]}" "${PWD//*\/}"
					}
				done <<< "$GET_TTLS"

				cd - > /dev/null
			}
		}
	}

	alias logttl="GIT_COMMIT_TOTALS"

	for CMD in\
	\
		"rm":grm "add":add "tag":tag "push":push "pull":pull "diff":diff\
		"init":init "clone":clone "merge":merge "branch":branch\
		"config":config "rm --cached":grmc "commit -m":commit\
		"status -s":status "checkout":checkout "config --list":gcl\
		"describe --long --tag":describe;
	{
		alias "${CMD/*:}"="/usr/bin/git ${CMD%:*}"
	}
}

# If you have gvfs-trash available, be safe with that.
[ -x /usr/bin/gvfs-trash ] && alias rm="/usr/bin/gvfs-trash"

# Ease-of-use youtube-dl aliases; these save typing!
for DEP in /usr/{local/bin,bin}/youtube-dl; {
	[ -x "$DEP" ] && {
		alias ytdl-video="/usr/local/bin/youtube-dl -c --yes-playlist\
			--sleep-interval 5 --max-sleep-interval 30 --format best\
			--no-call-home --console-title --quiet --ignore-errors"
		alias ytdl-audio="/usr/local/bin/youtube-dl -cx --audio-format mp3\
			--sleep-interval 5 --max-sleep-interval 30 --no-call-home\
			--console-title --quiet --ignore-errors"
		alias ytpldl-audio="/usr/local/bin/youtube-dl -cix --audio-format mp3\
			--sleep-interval 5 --max-sleep-interval 30 --yes-playlist\
			--no-call-home --console-title --quiet --ignore-errors"
		alias ytpldl-video="/usr/local/bin/youtube-dl -ci --yes-playlist\
			--sleep-interval 5 --max-sleep-interval 30 --format best\
			--no-call-home --console-title --quiet --ignore-errors"

		# Just use the first result.
		break
	}
}

# Various [q]uick apt-get aliases to make life a bit easier.
[ -x /usr/bin/apt-get ] && {
	for CMD in\
	\
		quf:"remove --purge" qufu:"remove --purge --autoremove"\
		qu:"remove" qa:"autoremove" qi:"install" qri:"reinstall"\
		qupd:"update" qupg:"upgrade" qdupg:"dist-upgrade"
	{
		alias ${CMD%:*}="/usr/bin/apt-get ${CMD/*:}"
	}
}

# Various [q]uick apt-cache aliases to make lifeeasier still.
[ -x /usr/bin/apt-cache ] && {
	for CMD in qse:"search" qsh:"show"; {
		alias ${CMD%:*}="/usr/bin/apt-cache ${CMD/*:}"
	}
}

# Workaround for older versions of dd; displays progress.
declare -i DEPCOUNT=0
for DEP in /bin/{dd,pidof}; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	[ $DEPCOUNT -gt 3 ] && {
		alias ddp="kill -USR1 `/bin/pidof /bin/dd`"
	}
}

# Display a detailed list of kernel modules currently in use.
declare -i DEPCOUNT=0
for DEP in /sbin/{modinfo,lsmod} /usr/bin/cut; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	[ $DEPCOUNT -eq 3 ] && {
		alias lsmodd='\
			for MOD in `/sbin/lsmod | /usr/bin/cut -d " " -f 1`; {
				printf "$MOD - "
				/sbin/modinfo -d "$MOD"
			}
		'
	}
}

# This is just options I find the most useful when using dmesg.
[ -x /bin/dmesg ] && alias klog="/bin/dmesg -t -L=never -l err,crit,alert,emerg"

# Enable the default hostkey when vboxsdl is used, if virtualbox GUI is not found.
{ [ -x /usr/bin/vboxsdl ] && ! [ -x /usr/bin/virtualbox ]; } && {
	alias vboxsdl="/usr/bin/vboxsdl --hostkey 305 128"
}

# Clear the clipboard using xclip.
[ -x /usr/bin/xclip ] && {
	alias ccb='\
		for X in "-i" "-i -selection clipboard"; {
			printf "%s" "" | /usr/bin/xclip $X
		}
	'
}

# Get more functionality by default when using grep and ls.
{ [ -x /bin/ls ] && [ -x /bin/grep ]; } && {
	case "${TERM:-EMPTY}" in
	        linux|xterm|xterm-256color)
	                alias ls="/bin/ls -nphq --time-style=iso --color=auto --group-directories-first"
	                alias lsa="/bin/ls -Anphq --time-style=iso --color=auto --group-directories-first"
	                alias grep="/bin/grep --color=auto"
	                alias egrep="/bin/egrep --color=auto"
	                alias fgrep="/bin/fgrep --color=auto" ;;
	esac
}

[ -x /usr/bin/pgrep ] && alias pgrep="/bin/pgrep --color=auto"

# Quick navigation aliases in absence of the autocd shell option.
shopt -qp autocd || {
	alias ~="cd $HOME"
	alias ..="cd .."
}

# For each directory listed to the left of :, create an alias you see on the right
# of :. This is a key=value style approach, like dictionaries in Python. HOME only.
for DIR in\
\
	"Music":mus "GitHub":gh "Videos":vid "Desktop":dt "Pictures":pic\
	"Downloads":dl "Documents":doc "Documents/TT":tt "ShellPlugins":sp\
	"GitHub/terminalforlife":ghtfl "GitHub/terminalforlife/Forks":ghtflf\
	"GitHub/terminalforlife/Personal":ghtflp;
{
	[ -d "$HOME/${DIR%:*}" ] && alias ${DIR/*:}="cd $HOME/${DIR%:*}"
}

# When dealing with udisksctl or mount, these are very useful!
[ -d "/media/$USER" ] && alias sd="cd /media/$USER" || alias mnt="cd /mnt"

# For each found "sr" device, enables alias for opening and closing the tray. For
# example, use ot0 to specific you want the tray for /dev/sr0 to open.
[ -x /usr/bin/eject ] && {
	for DEV in /dev/sr+([0-9]); {
		alias ot${DEV/\/dev\/sr}="/usr/bin/eject $DEV"
		alias ct${DEV/\/dev\/sr}="/usr/bin/eject -t $DEV"
	}
}

# These aliases save a lot of typing and do away with the output.
[ -x /usr/bin/mplayer ] && {
	# If you're having issues with mpv/mplayer here, try -vo x11 instead.
	MPLAYER_FONT="$HOME/.mplayer/subfont.ttf"
	alias mpa="/usr/bin/mplayer -nolirc -vo null -really-quiet &> /dev/null"

	[ -f "$MPLAYER_FONT" ] && {
		alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc -font \"$MPLAYER_FONT\" -really-quiet &> /dev/null"
		alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc -font \"$MPLAYER_FONT\" -really-quiet dvd://1//dev/sr1 &> /dev/null"
	} || {
		alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc -really-quiet &> /dev/null &> /dev/null"
		alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc --really-quiet dvd://1//dev/sr1 &> /dev/null"
	}
}

# Display only a certain type of package. Use: ls{ess,req,opt,ext}pkg
{ [ -x /usr/bin/dpkg-query ] && [ -x /usr/bin/column ]; } && {
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
[ -x /usr/bin/links2 ] && {
	L2_FUNC(){
		/usr/bin/links2 -http.do-not-track 1 -html-tables 1\
			-html-tables 1 -html-numbered-links 1\
			http://duckduckgo.com/?q="$*"
	}

	alias l2='L2_FUNC'
}

# A more descriptive, yet concise lsblk; you'll miss it when it's gone.
{ [ -x /bin/lsblk ] && [ -x /bin/grep ]; } && {
	alias lsblkid='\
		/bin/lsblk -o name,label,fstype,size,uuid,mountpoint --noheadings -l\
			| /bin/grep -v "^sd[a-z]\s"
	'
}

# Some options I like to have by default for less and pager.
declare -i DEPCOUNT=0
for DEP in /usr/bin/{pager,less}; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	[ $DEPCOUNT -eq 2 ] && {
		alias pager='/usr/bin/pager -sN --tilde'
		alias less='/usr/bin/pager -sN --tilde'
	}
}

# Text files I occasionally like to view, but not edit.
[ -x /usr/bin/pager ] && {
	for FILE in\
	\
		"/var/log/apt/history.log":aptlog\
		"$HOME/Documents/TT/python/Module\ Index.txt":pymodindex;
	{
		{ [ -f "${FILE%:*}" ] && [ -r "${FILE%:*}" ]; } && {
			alias ${FILE/*:}="/usr/bin/pager ${FILE%:*}"
		}
	}
}

[ -x /usr/bin/vim ] && {
	# Many files I often edit; usually configuration files.
	for FILE in\
	\
		".zshrc":zshrc ".vimrc":vimrc ".bashrc":bashrc ".conkyrc":conkyrc\
		".profile":profile ".i3blocks.conf":i3b1 ".i3blocks2.conf":i3b2\
		".config/i3/config":i3c "bin/maintain":maintain-sh\
		".bash_aliases":bashaliases ".config/compton.conf":compconf\
		"Documents/TT/Useful_Commands":cn\
		".maintain/changelog.txt":maintain-cl\
		".maintain/maintain.man":maintain-man\
		".maintain/usersettings.conf":maintain-set
	{
		[ -f "${FILE%:*}" ] || continue
		alias ${FILE/*:}="/usr/bin/vim $HOME/${FILE%:*}"
	}
	
	# As above, but for those which need root privileges.
	for FILE in\
	\
		"/etc/hosts":hosts "/etc/fstab":fstab "/etc/modules":modules\
		"/etc/pam.d/login":pamlogin "/etc/bash.bashrc":bash.bashrc\
		"$HOME/bin/maintain":maintain-sh\
		"/etc/X11/default-display-manager":ddm\
		"/etc/X11/default-display-manager":defdm\
		"/etc/modprobe.d/blacklist.conf":blacklist
	{
		[ -f "${FILE%:*}" ] || continue
		alias ${FILE/*:}="/usr/bin/vim ${FILE%:*}"
	}
}

# When in a TTY, change to different ones.
[[ `/usr/bin/tty` == /dev/tty* ]] && {
	{ [ -x /usr/bin/tty ] && [ -x /bin/chvt ]; } && {
		for TTY in {1..12}; {
			alias $TTY="chvt $TTY"
		}
	}
}

[ -x /usr/bin/evince ] && {
	alias pdf="/usr/bin/evince &> /dev/null"
}

# Clean up functions and variables.
unset -f FOR_THE_EDITOR
unset DEP FILE DEPCOUNT FOR_THE_EDITOR TTDIR DIR CHOSEN_EDITOR
