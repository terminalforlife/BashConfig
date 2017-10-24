#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Tue 24 Oct 22:35:44 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

# Just in-case.
[ -z "$BASH_VERSION" ] && return 1

# Quickly view all of your sd* storage device temperatures.
{ [ -x /usr/bin/sudo ] && [ -x /usr/sbin/hddtemp ]; } && {
	alias temphdd='/usr/bin/sudo /usr/sbin/hddtemp /dev/sd{a..z} 2> /dev/null'
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
{ [ -x /usr/bin/sudo ] && [ -x /bin/mount ] && [ -x /bin/umount ]; } && {
	RAMDISK="/media/$USER/RAMDisk_512M"

	alias rd='\
		/usr/bin/sudo /bin/mount -t tmpfs tmpfs\
			-o x-mount.mkdir=700,uid=1000,gid=1000,mode=700,nodev\
			-o noexec,nosuid,size=512M "$RAMDISK"
	'

	alias nord='\
		/usr/bin/sudo /bin/sh -c\
			/bin/umount\ "$RAMDISK"\ \&\&\ /bin/rmdir\ "$RAMDISK"
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
		"add":add\
		"tag":tag\
		"push":push\
		"diff":diff\
		"init":init\
		"merge":merge\
		"branch":branch\
		"config":config\
		"commit -m":commit\
		"status -s":status\
		"checkout":checkout\
		"config --list":gcl\
		"describe --long --tag":describe;
	{
		alias "${CMD/*:}"="/usr/bin/git ${CMD%:*}"
	}
}

# I prefer a builtin, for the same functionality.
alias dep="command -v"

# If you have gvfs-trash available, be safe with that.
[ -x /usr/bin/gvfs-trash ] && {
	alias rm="/usr/bin/gvfs-trash"
}

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
	for CMD in quf:"remove --purge" qufu:"remove --purge --autoremove"\
		   qu:"remove" qa:"autoremove" qi:"install" qri:"reinstall"\
		   qupd:"update" qupg:"upgrade" qdupg:"dist-upgrade"
	{
		alias ${CMD%:*}="/usr/bin/sudo /usr/bin/apt-get ${CMD/*:}"
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
for DEP in /bin/{dd,pidof} /usr/bin/sudo; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	[ $DEPCOUNT -gt 3 ] && {
		alias ddp="/usr/bin/sudo kill -USR1 `/bin/pidof /bin/dd`"
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
[ -x /bin/dmesg ] && {
	alias klog="/bin/dmesg -t -L=never -l err,crit,alert,emerg"
}

# Enable the default hostkey when vboxsdl is used.
[ -x /usr/bin/vboxsdl ] && {
	alias vboxsdl="/usr/bin/vboxsdl --hostkey 305 128"
}

# Clear the clipboard using xclip.
[ -x /usr/bin/xclip ] && {
	alias ccb="printf \"\" | /usr/bin/xclip -i"
}

# Get more functionality by default when using grep and ls.
declare -i DEPCOUNT=0
for DEP in /bin/{ls,grep}; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	[ $DEPCOUNT -eq 2 ] && {
		case "${TERM:-EMPTY}"
		in
		        linux|xterm|xterm-256color)
		                alias ls="/bin/ls -nphq --time-style=iso --color=auto --group-directories-first"
		                alias lsa="/bin/ls -Anphq --time-style=iso --color=auto --group-directories-first"
		                alias grep="/bin/grep --color=auto"
		                alias egrep="/bin/egrep --color=auto"
		                alias fgrep="/bin/fgrep --color=auto" ;;
		esac
	}
}

# Quick navigation aliases in absence of the autocd shell option.
shopt -qp autocd || {
	alias ~="cd $HOME"
	alias ..="cd .."
}

# For each directory listed to the left of :, create an alias you see on the right
# of :. This is a key=value style approach, like dictionaries in Python. HOME only.
for DIR in\
\
	"Music":mus\
	"GitHub":gh\
	"Videos":vid\
	"Desktop":dt\
	"Pictures":pic\
	"Downloads":dl\
	"Documents":doc\
	"Documents/TT":tt\
	"ShellPlugins":sp\
	"GitHub/terminalforlife":ghtfl\
	"GitHub/terminalforlife/Forks":ghtflf\
	"GitHub/terminalforlife/Personal":ghtflp
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
		#alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -vf pp=hb/vb/ha/va/h1/v1/dr/fq/fa,hqdn3d=6:6,gradfun=1.2 -zoom -nolirc -font \"$MPLAYER_FONT\" -really-quiet &> /dev/null"
		#alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -vf pp=hb/vb/ha/va/h1/v1/dr/fq/fa,hqdn3d=6:6,gradfun=1.2 -zoom -nolirc -font \"$MPLAYER_FONT\" -really-quiet dvd://1//dev/sr1 &> /dev/null"
		alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc -font \"$MPLAYER_FONT\" -really-quiet &> /dev/null"
		alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc -font \"$MPLAYER_FONT\" -really-quiet dvd://1//dev/sr1 &> /dev/null"
	} || {
		#alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -vf pp=hb/vb/ha/va/h1/v1/dr/fq/fa,hqdn3d=6:6,gradfun=1.2 -zoom -nolirc -really-quiet &> /dev/null &> /dev/null"
		#alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -vf pp=hb/vb/ha/va/h1/v1/dr/fq/fa,hqdn3d=6:6,gradfun=1.2 -zoom -nolirc --really-quiet dvd://1//dev/sr1 &> /dev/null"
		alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc -really-quiet &> /dev/null &> /dev/null"
		alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc --really-quiet dvd://1//dev/sr1 &> /dev/null"
	}
}

# Four little plugins I wrote for displaying only a certain type of package.
declare -i DEPCOUNT=0
for DEP in /usr/bin/{cut,dpkg-query,uniq,column} /bin/grep; {
	[ -x "$DEP" ] && DEPCOUNT+=1
	
	[ $DEPCOUNT -eq 5 ] && {
		# Display essential packages.
		alias lsesspkg='/usr/bin/dpkg-query --show\
			-f="\${Essential} \${Package}\n" \*\
			| /bin/grep "^yes"\
			| /usr/bin/cut -d " " -f 2\
			| /usr/bin/uniq\
			| /usr/bin/column'

		# Display required packages.
		alias lsreqpkg='/usr/bin/dpkg-query --show\
			-f="\${package} \${Priority}\n" \*\
			| /bin/grep " \(required\)\$"\
			| /usr/bin/uniq\
			| /usr/bin/cut -d " " -f 1\
			| /usr/bin/column'

		# Display optional packages.
		alias lsoptpkg='/usr/bin/dpkg-query --show\
			-f="\${package} \${Priority}\n" \*\
			| /bin/grep " \(optional\)\$"\
			| /usr/bin/uniq\
			| /usr/bin/cut -d " " -f 1\
			| /usr/bin/column'

		# Display extra packages.
		alias lsextpkg='/usr/bin/dpkg-query --show\
			-f="\${package} \${Priority}\n" \*\
			| /bin/grep " \(extra\)\$"\
			| /usr/bin/uniq\
			| /usr/bin/cut -d " " -f 1\
			| /usr/bin/column'
	}
}

# My preferred links2 settings; I recommend!
[ -x /usr/bin/links2 ] && {
	alias l2="links2 -http.do-not-track 1 -html-tables 1 -html-tables 1\
		-html-numbered-links 1 duckduckgo.co.uk"
}

# A more descriptive lsblk; you'll miss it when it's gone.
[ -x /bin/lsblk ] && {
	alias lsblkid="/bin/lsblk -o name,label,fstype,size,uuid,mountpoint"
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

# Many files I often edit; usually configuration files.
FOR_THE_EDITOR(){
	for FILE in\
	\
		".zshrc":zshrc\
		".vimrc":vimrc\
		".bashrc":bashrc\
		".conkyrc":conkyrc\
		".profile":profile\
		".i3blocks.conf":i3b1\
		".i3blocks2.conf":i3b2\
		".config/i3/config":i3c\
		"bin/maintain":maintain-sh\
		".bash_aliases":bashaliases\
		".config/compton.conf":compconf\
		"Documents/TT/Useful_Commands":cn\
		".maintain/changelog.txt":maintain-cl\
		".maintain/maintain.man":maintain-man\
		".maintain/usersettings.conf":maintain-set
	{
		[ -f "${FILE%:*}" ] || continue
		alias ${FILE/*:}="$1 $HOME/${FILE%:*}"
	}
}

# As above, but for those which use sudo -e.
FOR_THE_EDITOR_R(){
	for FILE in\
	\
		"/etc/hosts":hosts\
		"/etc/fstab":fstab\
		"/etc/modules":modules\
		"/etc/pam.d/login":pamlogin\
		"/etc/bash.bashrc":bash.bashrc\
		"$HOME/bin/maintain":maintain-sh\
		"/etc/X11/default-display-manager":ddm\
		"/etc/X11/default-display-manager":defdm\
		"/etc/modprobe.d/blacklist.conf":blacklist
	{
		[ -f "${FILE%:*}" ] || continue
		alias ${FILE/*:}="$1 ${FILE%:*}"
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

# Saves repeating for every possible editor; caveat? User input.
CHK_FOR_THE_EDITOR(){
	[ -x "$1" ] && {
		FOR_THE_EDITOR "$2"
	
		[ -z "$SUDO_EDITOR" ]\
			&& FOR_THE_EDITOR_R "/usr/bin/sudo $1"\
			|| FOR_THE_EDITOR_R "/usr/bin/sudo -e"
	}
}

# Enter your desired editor, as you see below.
CHK_FOR_THE_EDITOR "/usr/bin/vim" "vim"

[ -x /usr/bin/evince ] && {
	alias pdf="/usr/bin/evince &> /dev/null"
}

# Clean up functions and variables.
unset -f FOR_THE_EDITOR_R FOR_THE_EDITOR CHK_FOR_THE_EDITOR
unset DEP FILE DEPCOUNT FOR_THE_EDITOR TTDIR DIR
