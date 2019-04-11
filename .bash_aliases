#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Tue  9 Apr 19:00:52 BST 2019
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
#
# IMPORTANT:
#
#   All aliases you wish to be listed with lad (bashconfig/lad) MUST be one-liners
#   and have ' #: ' appended to each alias line, followed by its brief description.
#
#   Those which you don't, must be at least 3 tabs in to be ignored by lad. This
#   may change in future versions of lad.
#----------------------------------------------------------------------------------

# Just in-case.
[ -z "$BASH_VERSION" ] && return 1

# Nifty trick to allow aliases to work with sudo. This avoids needing sudo in these
# configuration files, since using sudo within a bash script/program is not great.
alias sudo="sudo " #: Allows for aliases to work with sudo.

# Sick of typing this in the termanal, out of habit!
alias ":q"="exit" #: Act expectedly, if it were actually VIM.

if [ -x /bin/df ]; then
	alias df='/bin/df -lT -x devtmpfs -x tmpfs -x usbfs' #: More relevant output than the default.
fi

# Display a list of all of the currently available font families.
if [ -x /usr/bin/fc-list ]; then
	alias lsfont="/usr/bin/fc-list : family" #: List all of the currently available font families.
fi

# List the contents of the trash bin. (Including hidden files?)
if [ -x /usr/bin/gvfs-ls ]; then
	alias lstrash="/usr/bin/gvfs-ls -h trash:///" #: List all contents of the trash bin.
fi

# View the entire (17,000+ lines) VIM User Guide.
if [ -x /bin/cat -a -x /usr/bin/vim  ]; then
	alias vug='/bin/cat /usr/share/vim/vim74/doc/usr_*.txt | /usr/bin/vim -' #: View the entire VIM User Guide.
fi

# A useful file to edit, if you use the X Display Manager.
if [ -x /usr/bin/xdm -a -f /etc/X11/xdm/Xresources ]; then
	alias xdm-xresources='/usr/bin/rvim /etc/X11/xdm/Xresources' #: Useful file to edit if you use the X Display Manager.
fi

# A less excessive, yet still very, very useful current-user-focused ps command.
if [ -x /bin/ps ]; then
	alias ps='/bin/ps -faxc -U $UID -o pid,uid,gid,pcpu,pmem,stat,comm' #: Less excessive, current-user-focused ps alternative.
fi

# This is where I usually have the main bulk of my music, and since I like to have
# little in my $HOME, I might as well just point mplay/MOC to the one on Main Data.
if [ -x /usr/bin/mplay ]; then
	alias mplay='/usr/bin/mplay /media/$USER/Main\ Data/Linux\ Generals/Music' #: Execute mplay (uses MOC) with a pre-specified directory.
fi

# I'm done with the boring original apt-get output! I'm also sick of specifying
# --purge --autoremove, so I want it to be assumed! A much more useful apt-get.
if [ -x /usr/bin/apt-get ]; then
	alias apt-get='/usr/bin/apt-get --quiet -o Dpkg::Progress=true -o Dpkg::Progress-Fancy=true -o APT::Get::AutomaticRemove=true -o APT::Get::Purge=true ' #: Much nicer output for the apt-get command.
fi

# Quick alias to clear out some junk from HOME.
if [ -x /bin/rm ]; then
	PLACES=(\
		"$HOME/.cache"
		"$HOME/.thumbnails"
		"$HOME/.mozilla/firefox/Crash Reports"
		"$HOME/.mozilla/firefox/Pending Pings"
	)

	alias hsh="/bin/rm --interactive=never -rv ${PLACES[@]} 2> /dev/null" #: Clear out some junk from the current user's HOME.
fi

# Make the ffmpeg output less cluttered, but also ignore many errors.
if [ -x /usr/bin/ffmpeg ]; then
	alias ffmpeg="ffmpeg -v 0 -stats" #: De-clutter this program's output, but not entirely.
fi

# Just points to a personal script for moving my screenshots.
if { [ "$USER" == "ichy" ] && [ $UID -eq 1000 ]; }\
&& [ -f "$HOME/Documents/TT/shotmngr.sh" ]; then
	alias sm="/bin/bash $HOME/Documents/TT/shotmngr.sh" #: Personal script for managing screenshots.
fi


# Used to notify you of a job completion on the terminal. I use this with dunst.
if [ -x /usr/bin/notify-send -a -x /usr/bin/tty ]; then
	# Standard notification.
	alias yo='/usr/bin/notify-send --urgency=normal "Your normal job in `/usr/bin/tty` has completed."' #: Perform a standard notify-send notification.

	# Urgent notification.
	alias YO='/usr/bin/notify-send --urgency=critical "Your critical job in `/usr/bin/tty` has completed."' #: Perform an urgent notify-send notification.
fi

# Used to use gpicview, until I realised feh could be used as an image viewer!
if [ -x /usr/bin/feh ]; then
	alias img='/usr/bin/feh --fullscreen --hide-pointer --draw-filename --no-menus --preload 2> /dev/null' #: Slide-show images in current directory using feh.
fi

# Quickly flash the terminal and sound the bell 3 times.
if [ -x /bin/sleep ]; then
	alias alertme='for I in {1..3}; { /bin/sleep 0.03s; printf "\a\e[?5h"; /bin/sleep 0.03s; printf "\a\e[?5l"; }' #: Sound the bell and flash the terminal (white) thrice.
fi

# Remove trailing spaces or lines with only spaces. Tabs included. Needs testing.
if [ -x /bin/sed ]; then
	alias nospace='/bin/sed s/^[\\s\\t]\\+$//\;\ s/[\\s\\t]\\+$//' #: Remove trailing spaces/tabs from given file(s).
	alias nospacei='/bin/sed -i s/^[\\s\\t]\\+$//\;\ s/[\\s\\t]\\+$//' #: Remove (saves!) trailing spaces/tabs from given file(s).
fi

# Efficient and fairly portable way to display the current iface, using 'ip'.
if [ -x /sbin/ip ]; then
	alias iface='X=(`/sbin/ip route`) && printf "%s\n" ${X[4]}' #: Display the current iface, using the 'ip' command.
fi

if [ -x /usr/sbin/hddtemp ]; then
	alias temphdd='/usr/sbin/hddtemp /dev/sd{a..z} 2> /dev/null' #: View all sd* storage device temperatures.
fi

if [ -x /usr/bin/wget ]; then
	alias get='/usr/bin/wget -qc --show-progress' #: Download with wget, using some tidier settings with -c.
fi

if [ -f /var/log/boot.log ]; then
	alias bootlog='while read -r; do printf "%s\n" "$REPLY"; done < /var/log/boot.log' #: View the system boot log, with colors.
fi

if [ -x /usr/bin/newsbeuter ]; then
	alias news='/usr/bin/newsbeuter -qr -c "$HOME/.newsbeuter/cache.db" -u "$HOME/.newsbeuter/urls" -C "$HOME/.newsbeuter/newsbeuter.conf"' #: Load newsbeuter more quickly to get access to RSS feeds.
	alias rss='/usr/bin/vim $HOME/.newsbeuter/urls' #: Edit a list of RSS feeds, using VIM.
fi

# Watches a directory as its size and number of files increase. Useful while you're
# downloading or making other sorts of changes to its contents, and want to watch.
if [ -x /bin/ls -a -x /usr/bin/watch ]; then
	alias dwatch='/usr/bin/watch -n 0.1 "/bin/ls -SsCphq --color=auto --group-directories-first"' #: Watche a directory for changes in size and number of files.
fi

# Fix all CWD file and directory permissions to match the safer 0077 umask.
if [ -x /bin/chmod ]; then
	alias fixperms='/usr/bin/find -xdev \( -type f -exec /bin/chmod 600 "{}" \+ -o -type d -exec /bin/chmod 700 "{}" \+ \) -printf "FIXING: %p\n" 2> /dev/null' #: Recursive fix of permissions in the CWD. (F:600 D:700)
fi

# Create or unmount a user-only RAM Disk (tmpfs, basically) of 32MB.
if [ -x /bin/mount -a -x /bin/umount ]; then
	RAMDISK="/media/$USER/RAMDisk_32M"

	alias rd='/bin/mount -t tmpfs tmpfs -o x-mount.mkdir=700,uid=1000,gid=1000,mode=700,nodev -o noexec,nosuid,size=32M "$RAMDISK"' #: Create a user-only RAM Disk (tmpfs) of 32MB.
	alias nord='/bin/sh -c /bin/umount\ "$RAMDISK"\ \&\&\ /bin/rmdir\ "$RAMDISK"' #: Remove a RAM Disk created with the 'rd' alias.
fi

#TODO - Needs testing and possibly finishing; incomplete?
# Rip audio CDs with ease, then convert to ogg, name, and tag. Change the device
# as fits your needs, same with the formats used.
#declare -i DEPCOUNT=0
#for DEP in /usr/bin/{eject,kid3,ffmpeg,cdparanoia}; {
#	[ -x "$DEP" ] && DEPCOUNT+=1
#
#	# Only execute if all 3 dependencies are found.
#	if [ $DEPCOUNT -eq 4 ]; then
#		alias cdrip='\
#			/usr/bin/cdparanoia -B 1- && {
#				for FILE in *; {
#					/usr/bin/ffmpeg -i "$FILE"\
#						"${FILE%.wav}.ogg" &> /dev/null
#				}
#			}
#		'
#	fi
#}

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
[ -x /usr/bin/gvfs-trash ] && alias rm="/usr/bin/gvfs-trash" #: ??? #: Use gvfs-trash in place of rm, if available.

# Ease-of-use youtube-dl aliases; these save typing!
for DEP in /usr/{local/bin,bin}/youtube-dl; {
	[ -x "$DEP" ] && {
		alias ytdl-video="$DEP -c --no-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube, using youtube-dl.
		alias ytdl-audio="$DEP -cx --no-playlist --audio-format mp3 --sleep-interval 5 --max-sleep-interval 30 --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube, using youtube-dl.
		alias ytpldl-audio="$DEP -cix --audio-format mp3 --sleep-interval 5 --yes-playlist --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube playlist, using youtube-dl.
		alias ytpldl-video="$DEP -ci --yes-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube playlist, using youtube-dl.

		# Just use the first result; no need to check for more.
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
		alias ${CMD%:*}="/usr/bin/apt-get ${CMD/*:}" #: ???
	}
fi

# Various [q]uick apt-cache aliases to make lifeeasier still.
if [ -x /usr/bin/apt-cache ]; then
	for CMD in qse:"search" qsh:"show"; {
		alias ${CMD%:*}="/usr/bin/apt-cache ${CMD/*:}" #: ???
	}
fi

# Workaround for older versions of dd; displays progress.
declare -i DEPCOUNT=0
for DEP in /bin/{dd,pidof}; {
	[ -x "$DEP" ] && DEPCOUNT+=1

	[ $DEPCOUNT -gt 3 ] && {
		alias ddp="kill -USR1 `/bin/pidof /bin/dd`" #: Workaround for older versions of dd; displays progress.
	}
}

# These are just options I find the most useful when using dmesg.
if [ -x /bin/dmesg ]; then
	alias klog="/bin/dmesg -t -L=never -l err,crit,alert,emerg" #: Potentially useful option for viewing the kernel log.
fi

# Enable the default hostkey when vboxsdl is used, if virtualbox gui is not found.
if [ -x /usr/bin/vboxsdl -a ! -x /usr/bin/virtualbox ]; then
	alias vboxsdl="/usr/bin/vboxsdl --hostkey 305 128" #: Enable the default hostkey when only vboxsdl is found.
fi

# Clear the clipboard using xclip.
if [ -x /usr/bin/xclip ]; then
	alias ccb='for X in "-i" "-i -selection clipboard"; { printf "%s" "" | /usr/bin/xclip $X}' #: Clear the clipboard using xclip.
fi

# Get more functionality by default when using grep and ls.
if [ -x /bin/ls -a -x /bin/grep ]; then
	case "${TERM:-EMPTY}" in
	        linux|xterm|xterm-256color)
	                alias ls="/bin/ls --quoting-style=literal -nphq --time-style=iso --color=auto --group-directories-first --show-control-chars" #: A stylish, informative alternative to the 'ls' standard.
			alias lsa="ls -A" #: As the previously set 'ls' alias, but show all files.

			alias grep="/bin/grep --color=auto" #: Colorful (auto) 'grep' output.
			alias egrep="/bin/egrep --color=auto" #: Colorful (auto) 'egrep' output.
			alias fgrep="/bin/fgrep --color=auto" #: Colorful (auto) 'fgrep' output.
			;;
	esac
fi

# Quick navigation aliases in absence of the autocd shell option.
shopt -qp autocd || {
	alias ~="cd $HOME" #: ???
	alias ..="cd .." #: ???
}

# For each directory listed to the left of :, create an alias you see on the right
# of :. This is a key=value style approach, like dictionaries in Python. HOME only.
for DIR in\
\
	"Music":mus "GitHub":gh "Videos":vid "Desktop":dt "Pictures":pic\
	"Downloads":dl "Documents":doc "Documents/TT":tt ".shplugs":sp\
	"GitHub/terminalforlife":ghtfl "GitHub/terminalforlife/Forks":ghtflf\
	"GitHub/terminalforlife/Personal":ghtflp "DosBox":db "Archives":arc\
	".i3a":i3a "LearnLinux":ll;
{
	[ -d "$HOME/${DIR%:*}" ] && alias ${DIR/*:}="cd $HOME/${DIR%:*}"
}

# When dealing with udisksctl or mount, these are very useful!
if [ -d "/media/$USER" ]; then
	alias sd="cd /media/$USER" #: Change the CWD to: /media/$USER
else
	alias mnt="cd /mnt" #: Change the CWD to: /mnt
fi

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
	alias mpa="/usr/bin/mplayer -nolirc -vo null -really-quiet &> /dev/null" #: Use 'mplayer' to play audio files, sans window or output.

	declare -a MPLAYER_FONT=("-font" "$HOME/.mplayer/subfont.ttf")
	if ! [ -f "${MPLAYER_FONT[0]}" ] || ! [ -r "${MPLAYER_FONT[0]}" ]; then
		unset MPLAYER_FONT
	fi

	alias mpv="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet &> /dev/null" #: Use 'mplayer' to play video files, sans output.
	alias mpvdvd="/usr/bin/mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet dvd://1//dev/sr1 &> /dev/null" #: Use 'mplayer' to play DVDs, sans output.
elif [ -x /usr/bin/mpv ]; then
	#alias mpvve="/usr/bin/mpv --af=equalizer=8:7:6:5:0:6:0:5:5:5 --no-stop-screensaver &> /dev/null "
	alias mpvv="/usr/bin/mpv --no-stop-screensaver &> /dev/null " #: Use 'mpv' to play video files, sans output.
fi

if [ -x /bin/lsblk ]; then
	alias lsblkid='/bin/lsblk -o name,label,fstype,size,uuid,mountpoint --noheadings' #: A more descriptive, yet concise lsblk.
fi

if [ -x /usr/bin/pager -o -x /usr/bin/less ]; then
	alias pager='/usr/bin/pager -sN --tilde' #: Useful options included with 'pager'.
	alias less='/usr/bin/pager -sN --tilde' #: Useful options included with 'less'.
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
		".libi3bview":li3bv ".config/herbstluftwm/autostart":hla\
		".config/herbstluftwm/panel.sh":panel;
	{
		[ -f "$HOME/${FILE%:*}" ] || continue
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
	alias pdf="/usr/bin/evince &> /dev/null" #: Use 'evince' to display PDF documents.
fi

# Clean up functions and variables.
unset -f FOR_THE_EDITOR
unset DEP FILE DEPCOUNT FOR_THE_EDITOR TTDIR DIR CHOSEN_EDITOR GIT

# vim: noexpandtab colorcolumn=84 tabstop=8 noswapfile nobackup
