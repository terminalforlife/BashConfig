#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Sun 11 Mar 09:30:35 GMT 2018
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# If you're looking for some aliases which were removed, look in the new file I
# added to keep functions and aliases separate: $HOME/.bash_functions
#
# You may need to update insit if you're installing from there, but note that this
# will of course blast away your current configurations:
#
#   sudo insit -S
#   sudo insit -U bashconfig
#----------------------------------------------------------------------------------

# Just in-case.
[ -z "$BASH_VERSION" ] && return 1

# Nifty trick to allow aliases to work with sudo. This avoids needing sudo in these
# configuration files, since using sudo within a bash script/program is not great.
alias sudo="sudo "

# Sick of typing this in the termanal, out of habit!
alias ":q"="exit"

# View the entire (17,000+ lines) VIM User Guide.
if [ -x /bin/cat -a -x /usr/bin/vim ]; then
	alias vug='/bin/cat /usr/share/vim/vim74/doc/usr_*.txt | /usr/bin/vim -'
fi

# ???
if [ -x /usr/bin/xdm -a -f /etc/X11/xdm/Xresources ]; then
	alias xdm-xresources='/usr/bin/rvim /etc/X11/xdm/Xresources'
fi

# A less excessive, yet still very, very useful current-user-focused ps command.
if [ -x /bin/ps ]; then
	alias ps='/bin/ps -faxc -U $UID -o pid,uid,gid,pcpu,pmem,stat,comm'
fi

# Log by default all actions by insit into: /var/log/tfl_insit.log
[ -x /usr/bin/insit ] && alias insit="/usr/bin/insit -L"

# This is where I usually have the main bulk of my music, and since I like to have
# little in my $HOME, I might as well just point mplay/MOC to the one on Main Data.
if [ -x /usr/bin/mplay ]; then
	alias mplay='/usr/bin/mplay /media/$USER/Main\ Data/Linux\ Generals/Music'
fi

# I'm done with the boring original apt-get output! I'm also sick of specifying
# --purge --autoremove, so I want it to be assumed! A much more useful apt-get.
if [ -x /usr/bin/apt-get ]; then
	alias apt-get='\
		/usr/bin/apt-get --quiet -o Dpkg::Progress=true\
		-o Dpkg::Progress-Fancy=true -o APT::Get::AutomaticRemove=true\
		-o APT::Get::Purge=true '
fi

# Display the current DPI setting.
if [ -x /usr/bin/xdpyinfo ]; then
	alias dpi='\
		while read -a X; do
			if [ "${X[0]}" == "resolution:" ]; then
				printf "%s\n" "${X[1]/*x}"
			fi
		done <<< "$(/usr/bin/xdpyinfo)"
	'
fi

# Quick alias to clear out some junk from HOME.
if [ -x /bin/rm ]; then
	PLACES=(\
		"$HOME/.cache"
		"$HOME/.thumbnails"
		"$HOME/.mozilla/firefox/Crash Reports"
		"$HOME/.mozilla/firefox/Pending Pings"
	)

	alias hsh="/bin/rm --interactive=never -rv ${PLACES[@]} 2> /dev/null"
fi

# Make the ffmpeg output less cluttered, but also ignore many errors.
[ -x /usr/bin/ffmpeg ] && alias ffmpeg="ffmpeg -v 0 -stats"

# Just points to a personal script for moving screenshots.
[ -f "$HOME/Documents/TT/iih" ] && alias iih="/bin/bash $HOME/Documents/TT/iih"

# Used to notify you of a job completion on the terminal.
if [ -x /usr/bin/notify-send -a -x /usr/bin/tty ]; then
	# Standard notification.
	alias yo='\
		/usr/bin/notify-send --urgency=normal\
			"Your normal job in `/usr/bin/tty` has completed."
	'

	# Urgent notification.
	alias YO='\
		/usr/bin/notify-send --urgency=critical\
			"Your critical job in `/usr/bin/tty` has completed."
	'
fi

# Used to use gpicview, until I realised feh could be used as an image viewer!
if [ -x /usr/bin/feh ]; then
	alias img='\
		/usr/bin/feh --fullscreen --hide-pointer --draw-filename\
			--no-menus --preload 2> /dev/null
	'
fi

# Very useful, quick alias to scan anything you specify, if you have clamscan.
if [ -x /usr/bin/clamscan -a -x /usr/bin/tee ]; then
	alias scan='\
		{
			printf "SCAN_START: %(%F (%X))T\n" -1
			/usr/bin/clamscan --bell -r --no-summary -i\
				--detect-pua=yes --detect-structured=no\
				--structured-cc-count=3 --structured-ssn-count=3\
				--phishing-ssl=yes --phishing-cloak=yes\
				--partition-intersection=yes --detect-broken=yes\
				--block-macros=yes --max-filesize=256M\
				|& /usr/bin/tee -a $HOME/.scan_alias.log
		} |& /usr/bin/tee -a $HOME/.scan_alias.log
	'
fi

# Quickly flash the terminal and sound the bell 3 times.
if [ -x /bin/sleep ]; then
	alias alertme='\
		for I in {1..3}; {
			/bin/sleep 0.03s
			printf "\a\e[?5h"
			/bin/sleep 0.03s
			printf "\a\e[?5l"
		}
	'
fi

# Remove trailing spaces or lines with only spaces. Tabs included. Needs testing.
[ -x /bin/sed ] && alias nospace='/bin/sed -i s/^[\\s\\t]\\+$//\;\ s/[\\s\\t]\\+$//'

# Efficient and fairly portable way to display the current iface.
[ -x /sbin/ip ] && alias iface='X=(`/sbin/ip route`) && echo ${X[4]}'

# Get and display the distribution type. (original base first)
if [ -f /etc/os-release -a -r /etc/os-release ]; then
	alias distro='\
		while read -a X; do
			if [[ "${X[0]}" == ID_LIKE=* ]]; then
				echo "${X[0]/*=}"; break
			elif [[ "${X[0]}" == ID=* ]]; then
				echo "${X[0]/*=}"; break
			fi
		done < /etc/os-release
	'
fi

# Quickly view all of your sd* storage device temperatures.
if [ -x /usr/sbin/hddtemp ]; then
	alias temphdd='/usr/sbin/hddtemp /dev/sd{a..z} 2> /dev/null'
fi

# Quickly download with wget, using some tider settings with -c.
if [ -x /usr/bin/wget ]; then
	alias get='/usr/bin/wget -qc --show-progress'
fi

# View the system boot log.
if [ -f /var/log/boot.log ]; then
	alias bootlog='\
		while read -r; do
			printf "%s\n" "$REPLY"
		done < /var/log/boot.log
	'
fi

if [ -x /usr/bin/newsbeuter ]; then
	# Load newsbeuter more quickly to get access to RSS feeds.
	alias news='\
		/usr/bin/newsbeuter -qr\
			-c "$HOME/.newsbeuter/cache.db"\
			-u "$HOME/.newsbeuter/urls"\
			-C "$HOME/.newsbeuter/newsbeuter.conf"
	'

	# Quickly edit RSS feed list.
	alias rss='/usr/bin/vim $HOME/.newsbeuter/urls'
fi

# Watches a directory as its size and number of files increase. Useful while you're
# downloading or making other sorts of changes to its contents, and want to watch.
if [ -x /bin/ls -a -x /usr/bin/watch ]; then
	alias dwatch='\
		/usr/bin/watch -n 0.1 "/bin/ls -SsCphq\
			--color=auto --group-directories-first"
	'
fi

# Fix all CWD file and directory permissions to match the safer 0077 umask.
if [ -x /bin/chmod ]; then
	alias fixperms='\
		/usr/bin/find -xdev \( -type f -exec /bin/chmod 600 "{}" \+ -o\
			-type d -exec /bin/chmod 700 "{}" \+ \)\
			-printf "FIXING: %p\n" 2> /dev/null
	'
fi

# Create or unmount a user-only RAM Disk (tmpfs, basically) of 512MB.
if [ -x /bin/mount -a -x /bin/umount ]; then
	RAMDISK="/media/$USER/RAMDisk_512M"

	alias rd='\
		/bin/mount -t tmpfs tmpfs\
			-o x-mount.mkdir=700,uid=1000,gid=1000,mode=700,nodev\
			-o noexec,nosuid,size=512M "$RAMDISK"
	'

	alias nord='\
		/bin/sh -c /bin/umount\ "$RAMDISK"\ \&\&\ /bin/rmdir\ "$RAMDISK"
	'
fi

# Show the fan speeds using sensors.
if [ -x /usr/bin/sensors ]; then
	alias showfans='\
		while read; do
			[[ "$REPLY" == *[Ff][Aa][Nn]*RPM ]] && echo "$REPLY"
		done <<< "$(/usr/bin/sensors)"
	'
fi

# Display a columnized list of bash builtins.
if [ -x /usr/bin/column ]; then
	alias builtins='\
		while read -r; do
			echo "${REPLY/* }"
		done <<< "$(enable -a)" | /usr/bin/column
	'
fi

# Rip audio CDs with ease, then convert to ogg, name, and tag. Change the device
# as fits your needs, same with the formats used. Needs testing.
declare -i DEPCOUNT=0
for DEP in /usr/bin/{eject,kid3,ffmpeg,cdparanoia}; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	# Only execute if all 3 dependencies are found.
	if [ $DEPCOUNT -eq 4 ]; then
		alias cdrip='\
			/usr/bin/cdparanoia -B 1- && {
				for FILE in *; {
					/usr/bin/ffmpeg -i "$FILE"\
						"${FILE%.wav}.ogg" &> /dev/null
				}
			}
		'
	fi
}

# Enable a bunch of git aliases, if you have git installed.
[ -x /usr/bin/git ] && {
	for CMD in\
	\
		"rm":grm "add":add "tag":tag "push":push "pull":pull "diff":diff\
		"init":init "clone":clone "merge":merge "branch":branch\
		"config":config "rm --cached":grmc "commit -m":commit\
		"status -s":status "checkout":checkout "config --list":gcl\
		"describe --long --tag":describe "mv":gmv;
	{
		alias "${CMD/*:}"="/usr/bin/git ${CMD%:*}"
	}
}

# If you have gvfs-trash available, be safe with that.
[ -x /usr/bin/gvfs-trash ] && alias rm="/usr/bin/gvfs-trash"

# Ease-of-use youtube-dl aliases; these save typing!
for DEP in /usr/{local/bin,bin}/youtube-dl; {
	[ -x "$DEP" ] && {
		alias ytdl-video="$DEP -c --yes-playlist --sleep-interval 5\
			--format best --no-call-home --console-title --quiet\
			--ignore-errors"

		alias ytdl-audio="$DEP -cx --audio-format mp3 --sleep-interval 5\
			--max-sleep-interval 30 --no-call-home --console-title\
			--quiet --ignore-errors"

		alias ytpldl-audio="$DEP -cix --audio-format mp3 --sleep-interval\
			5 --yes-playlist --no-call-home --console-title --quiet\
			--ignore-errors"

		alias ytpldl-video="$DEP -ci --yes-playlist --sleep-interval 5\
			--format best --no-call-home --console-title --quiet\
			--ignore-errors"

		# Just use the first result.
		break
	}
}

# Various [q]uick apt-get aliases to make life a bit easier.
if [ -x /usr/bin/apt-get ]; then
	for CMD in\
	\
		quf:"-qq --show-progress remove --purge"\
		qufu:"-qq --show-progress remove --purge --autoremove"\
		qu:"-qq --show-progress remove"\
		qa:"-qq --show-progress autoremove"\
		qi:"-qq --show-progress install"\
		qri:"-qq --show-progress reinstall"\
		qupg:"-qq --show-progress upgrade"\
		qdupg:"-qq --show-progress dist-upgrade"\
		qupd:"-q update"
	{
		alias ${CMD%:*}="/usr/bin/apt-get ${CMD/*:}"
	}
fi

# Various [q]uick apt-cache aliases to make lifeeasier still.
if [ -x /usr/bin/apt-cache ]; then
	for CMD in qse:"search" qsh:"show"; {
		alias ${CMD%:*}="/usr/bin/apt-cache ${CMD/*:}"
	}
fi

# Workaround for older versions of dd; displays progress.
declare -i DEPCOUNT=0
for DEP in /bin/{dd,pidof}; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	[ $DEPCOUNT -gt 3 ] && {
		alias ddp="kill -USR1 `/bin/pidof /bin/dd`"
	}
}

# These are just options I find the most useful when using dmesg.
[ -x /bin/dmesg ] && alias klog="/bin/dmesg -t -L=never -l err,crit,alert,emerg"

# Enable the default hostkey when vboxsdl is used, if virtualbox GUI is not found.
if [ -x /usr/bin/vboxsdl -a ! -x /usr/bin/virtualbox ]; then
	alias vboxsdl="/usr/bin/vboxsdl --hostkey 305 128"
fi

# Clear the clipboard using xclip.
if [ -x /usr/bin/xclip ]; then
	alias ccb='\
		for X in "-i" "-i -selection clipboard"; {
			printf "%s" "" | /usr/bin/xclip $X
		}
	'
fi

# Get more functionality by default when using grep and ls.
if [ -x /bin/ls -a -x /bin/grep ]; then
	case "${TERM:-EMPTY}" in
	        linux|xterm|xterm-256color)
	                alias ls="/bin/ls -nphq --time-style=iso --color=auto\
				--group-directories-first"

	                alias lsa="/bin/ls -Anphq --time-style=iso --color=auto\
				--group-directories-first"

	                alias grep="/bin/grep --color=auto"
	                alias egrep="/bin/egrep --color=auto"
	                alias fgrep="/bin/fgrep --color=auto" ;;
	esac
fi

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
	"GitHub/terminalforlife/Personal":ghtflp "DosBox":db "Archives":arc\
	".i3a":i3a;
{
	[ -d "$HOME/${DIR%:*}" ] && alias ${DIR/*:}="cd $HOME/${DIR%:*}"
}

# When dealing with udisksctl or mount, these are very useful!
[ -d "/media/$USER" ] && alias sd="cd /media/$USER" || alias mnt="cd /mnt"

# For each found "sr" device, enables alias for opening and closing the tray. For
# example, use ot0 to specific you want the tray for /dev/sr0 to open. Testing for
# /dev/sr0 to ensure at least the one device is available, to avoid errors.
if [ -x /usr/bin/eject -a -b /dev/sr0 ]; then
	for DEV in /dev/sr[0-9]*; {
		alias ot${DEV/\/dev\/sr}="/usr/bin/eject $DEV"
		alias ct${DEV/\/dev\/sr}="/usr/bin/eject -t $DEV"
	}
fi

# These aliases save a lot of typing and do away with the output.
if [ -x /usr/bin/mplayer ]; then
	# If you're having issues with mpv/mplayer here, try -vo x11 instead.
	MPLAYER_FONT="$HOME/.mplayer/subfont.ttf"
	alias mpa="/usr/bin/mplayer -nolirc -vo null -really-quiet &> /dev/null"

	if [ -f "$MPLAYER_FONT" ]; then
		alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar\
			-nojoystick -nogui -zoom -nolirc -font \"$MPLAYER_FONT\"\
			-really-quiet &> /dev/null"

		alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar\
			-nojoystick -nogui -zoom -nolirc -font \"$MPLAYER_FONT\"\
			-really-quiet dvd://1//dev/sr1 &> /dev/null"
	else
		alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar\
			-nojoystick -nogui -zoom -nolirc -really-quiet\
			&> /dev/null &> /dev/null"

		alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar\
			-nojoystick -nogui -zoom -nolirc --really-quiet\
			dvd://1//dev/sr1 &> /dev/null"
	fi
elif [ -x /usr/bin/mpv ]; then
	alias mpv="/usr/bin/mpv &> /dev/null"
fi

# A more descriptive, yet concise lsblk; you'll miss it when it's gone.
if [ -x /bin/lsblk ]; then
	alias lsblkid='\
		/bin/lsblk -o name,label,fstype,size,uuid,mountpoint --noheadings
	'
fi

# Some options I like to have by default for less and pager.
if [ -x /usr/bin/pager -o -x /usr/bin/less ]; then
	alias pager='/usr/bin/pager -sN --tilde'
	alias less='/usr/bin/pager -sN --tilde'
fi

# Text files I occasionally like to view, but not edit.
if [ -x /usr/bin/pager ]; then
	for FILE in\
	\
		"/var/log/apt/history.log":aptlog\
		"$HOME/Documents/TT/python/Module\ Index.txt":pymodindex;
	{
		{ [ -f "${FILE%:*}" ] && [ -r "${FILE%:*}" ]; } && {
			alias ${FILE/*:}="/usr/bin/pager ${FILE%:*}"
		}
	}
fi

if [ -x /usr/bin/vim ]; then
	# Many files I often edit; usually configuration files.
	for FILE in\
	\
		".zshrc":zshrc ".vimrc":vimrc ".bashrc":bashrc ".conkyrc":conkyrc\
		".profile":profile ".i3bbelow":i3b1 ".i3babove":i3b2\
		".config/i3/config":i3c "bin/maintain":maintain-sh\
		".bash_aliases":bashaliases ".config/compton.conf":compconf\
		"Documents/TT/Useful_Commands":cn "i3blocks1.conf":i3cb1\
		"Documents/TT/python/Useful_Commands.py":cnp\
		".maintain/changelog.txt":maintain-cl ".xbindkeysrc":xbkrc\
		".maintain/maintain.man":maintain-man ".config/openbox/rc.xml":obc\
		".maintain/usersettings.conf":maintain-set ".wgetrc":wgetrc\
		".dosbox/dosbox-0.74.conf":dbc ".bash_functions":bashfunctions\
		".libi3bview":li3bv;
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
		alias ${FILE/*:}="/usr/bin/rvim ${FILE%:*}"
	}
fi

# When in a TTY, change to different ones.
if [[ `/usr/bin/tty` == /dev/tty* ]] && [ -x /usr/bin/tty -a -x /bin/chvt ]; then
	for TTY in {1..12}; {
		alias $TTY="chvt $TTY"
	}
fi

if [ -x /usr/bin/evince ]; then
	alias pdf="/usr/bin/evince &> /dev/null"
fi

# Clean up functions and variables.
unset -f FOR_THE_EDITOR
unset DEP FILE DEPCOUNT FOR_THE_EDITOR TTDIR DIR CHOSEN_EDITOR

# vim: noexpandtab colorcolumn=84 tabstop=8 noswapfile nobackup
