#!/usr/bin/env bash

#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Tue 26 Nov 01:47:59 GMT 2019
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
[ "$BASH_VERSION" ] || return 1

# Nifty trick to allow aliases to work with sudo. This avoids needing sudo in these
# configuration files, since using sudo within a bash script/program is not great.
alias sudo="sudo " #: Allows for aliases to work with sudo.

# Sick of typing this in the termanal, out of habit!
alias ":q"="exit" #: Act expectedly, if it were actually VIM.

if type -fP df > /dev/null 2>&1; then
	alias df='df -lT -x devtmpfs -x tmpfs -x usbfs' #: More relevant output than the default.
fi

if type -fP perl > /dev/null 2>&1; then
	alias perl-lib-path="perl -e 'print(\"\$_\n\") foreach @INC'" #: List directories in which Perl looks for library files.
fi

# Display a list of all of the currently available font families.
if type -fP fc-list > /dev/null 2>&1; then
	alias lsfont="fc-list : family" #: List all of the currently available font families.
fi

# List the contents of the trash bin. (Including hidden files?)
if type -fP gvfs-ls > /dev/null 2>&1; then
	alias lstrash="gvfs-ls -h trash:///" #: List all contents of the trash bin.
fi

# View the entire (17,000+ lines) VIM User Guide.
if type -fP cat vim > /dev/null 2>&1; then
	alias vug='cat /usr/share/vim/vim74/doc/usr_*.txt | vim -' #: View the entire VIM User Guide.
fi

# A useful file to edit, if you use the X Display Manager.
if [ -f /etc/X11/xdm/Xresources ] && type -fP xdm > /dev/null 2>&1; then
	alias vug='cat /usr/share/vim/vim74/doc/usr_*.txt | vim -' #: View the entire VIM User Guide.
	alias xdm-xresources='rvim /etc/X11/xdm/Xresources' #: Useful file to edit if you use the X Display Manager.
fi

# A less excessive, yet still very, very useful current-user-focused ps command.
if type -fP ps > /dev/null 2>&1; then
	alias ps='ps -faxc -U $UID -o pid,uid,gid,pcpu,pmem,stat,comm' #: Less excessive, current-user-focused ps alternative.
fi

# This is where I usually have the main bulk of my music, and since I like to have
# little in my $HOME, I might as well just point mplay/MOC to the one on Main Data.
if [ $UID -eq 1000 -a $USER == 'ichy' ] && type -fP mplay > /dev/null 2>&1; then
	alias mplay='mplay /media/$USER/Main\ Data/Linux\ Generals/Music' #: Execute mplay (uses MOC) with a pre-specified directory.
fi

# I'm done with the boring original apt-get output! I'm also sick of specifying
# --purge --autoremove, so I want it to be assumed! A much more useful apt-get.
if type -fP apt-get > /dev/null 2>&1; then
	# Various [q]uick apt-get aliases to make life a bit easier.
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
		alias ${CMD%:*}="apt-get ${CMD/*:}" #: ???
	}

	alias apt-get='apt-get --quiet -o Dpkg::Progress=true -o Dpkg::Progress-Fancy=true -o APT::Get::AutomaticRemove=true -o APT::Get::Purge=true ' #: Much nicer output for the apt-get command.
fi

# Quick alias to clear out some junk from HOME.
if type -fP rm > /dev/null 2>&1; then
	PLACES=(\
		"$HOME/.cache"
		"$HOME/.thumbnails"
		"$HOME/.mozilla/firefox/Crash Reports"
		"$HOME/.mozilla/firefox/Pending Pings"
	)

	alias hsh="rm --interactive=never -rv ${PLACES[@]} 2> /dev/null" #: Clear out some junk from the current user's HOME.
fi

# Make the ffmpeg output less cluttered, but also ignore many errors.
if type -fP ffmpeg > /dev/null 2>&1; then
	alias ffmpeg="ffmpeg -v 0 -stats" #: De-clutter this program's output, but not entirely.
fi

# Just points to a personal script for moving my screenshots.
if [ "$USER" == "ichy" -a $UID -eq 1000 ] && [ -f "$HOME/Documents/TT/shotmngr.sh" ]; then
	alias sm="bash $HOME/Documents/TT/shotmngr.sh" #: Personal script for managing screenshots.
fi


# Used to notify you of a job completion on the terminal. I use this with dunst.
if type -fP notify-send tty > /dev/null 2>&1; then
	# Standard notification.
	alias yo='notify-send --urgency=normal "Your normal job in `tty` has completed."' #: Perform a standard notify-send notification.

	# Urgent notification.
	alias YO='notify-send --urgency=critical "Your critical job in `tty` has completed."' #: Perform an urgent notify-send notification.
fi

# Used to use gpicview, until I realised feh could be used as an image viewer!
if type -fP feh > /dev/null 2>&1; then
	if type -fP wget > /dev/null 2>&1; then
		alias getsetwall='wget -qO - "https://source.unsplash.com/random/1920x1080" | feh --bg-center -' #: Fetch and set a random 1920x1080 wallpaper.
		alias get='wget -qc --show-progress' #: Download with wget, using some tidier settings with -c.
	fi

	alias img='feh --fullscreen --hide-pointer --draw-filename --no-menus --preload 2> /dev/null' #: Slide-show images in current directory using feh.
fi

# Quickly flash the terminal and sound the bell 3 times.
if type -fP sleep > /dev/null 2>&1; then
	alias alertme='for I in {1..3}; { sleep 0.03s; printf "\a\e[?5h"; sleep 0.03s; printf "\a\e[?5l"; }' #: Sound the bell and flash the terminal (white) thrice.
fi

# Remove trailing spaces or lines with only spaces. Tabs included. Needs testing.
if type -fP sed > /dev/null 2>&1; then
	alias nospace='sed s/^[\\s\\t]\\+$//\;\ s/[\\s\\t]\\+$//' #: Remove trailing spaces/tabs from given file(s).
	alias nospacei='sed -i s/^[\\s\\t]\\+$//\;\ s/[\\s\\t]\\+$//' #: Remove (saves!) trailing spaces/tabs from given file(s).
fi

# Efficient and fairly portable way to display the current iface, using 'ip'.
if type -fP ip > /dev/null 2>&1; then
	alias iface='X=(`ip route`) && printf "%s\n" ${X[4]}' #: Display the current iface, using the 'ip' command.
fi

if type -fP hddtemp > /dev/null 2>&1; then
	alias temphdd='hddtemp /dev/sd{a..z} 2> /dev/null' #: View all sd* storage device temperatures.
fi

if [ -f /var/log/boot.log ]; then
	alias bootlog='while read -r; do printf "%s\n" "$REPLY"; done < /var/log/boot.log' #: View the system boot log, with colors.
fi

if type -fP newsbeuter > /dev/null 2>&1; then
	alias news='newsbeuter -qr -c "$HOME/.newsbeuter/cache.db" -u "$HOME/.newsbeuter/urls" -C "$HOME/.newsbeuter/newsbeuter.conf"' #: Load newsbeuter more quickly to get access to RSS feeds.
	alias rss='vim $HOME/.newsbeuter/urls' #: Edit a list of RSS feeds, using VIM.
fi

# Watches a directory as its size and number of files increase. Useful while you're
# downloading or making other sorts of changes to its contents, and want to watch.
if type -fP ls watch > /dev/null 2>&1; then
	alias dwatch='watch -n 0.1 "ls -SsCphq --color=auto --group-directories-first"' #: Watche a directory for changes in size and number of files.
fi

# Fix all CWD file and directory permissions to match the safer 0077 umask. The
# GitHub directory (/home/$USER/GitHub/) and its contents are protected from
# this, as it could cause quite the problem.
if type -fP chmod > /dev/null 2>&1; then
	alias fixperms='[[ "$PWD" == "/home/$USER/GitHub/"* ]] || find -xdev -not -path "*/GitHub/*" \( -type f -exec chmod 600 {} \+ -o -type d -exec chmod 700 "{}" \+ \) -exec chown $UID:$UID {} \+ -printf "FIXING: %p\n" 2> /dev/null' #: Recursively fix permissions and ownership. (F:600 D:700, UID:UID)
fi

# Create or unmount a user-only RAM Disk (tmpfs, basically) of 32MB.
if type -fP mount umount > /dev/null 2>&1; then
	RAMDISK="/media/$USER/RAMDisk_32M"

	alias rd='mount -t tmpfs tmpfs -o x-mount.mkdir=700,uid=1000,gid=1000,mode=700,nodev -o noexec,nosuid,size=32M "$RAMDISK"' #: Create a user-only RAM Disk (tmpfs) of 32MB.
	alias nord='sh -c umount\ "$RAMDISK"\ \&\&\ rmdir\ "$RAMDISK"' #: Remove a RAM Disk created with the 'rd' alias.
fi

# Enable a bunch of git aliases, if you have git installed.
if type -fP git > /dev/null 2>&1; then
	for CMD in\
	\
		"remote add upstream":raddup "rm":grm "add":add "tag":tag\
		"push":push "pull":pull "pull upstream":pullup "diff":diff\
		"init":init "clone":clone "merge":merge "branch":branch\
		"config":config "rm --cached":grmc "commit":commit\
		"status -s":status "checkout":checkout "config --list":gcl\
		"describe --long --tag":describe "mv":gmv "commit -m":scommit\
		"show --pretty=format:'%CredCommit %Cgreen%h%Cred pushed %ar by %Cgreen%an%Creset%Cred:%Creset%n\"%s\"%n'":show\
		"log --reverse --pretty=format:'%CredCommit %Cgreen%h%Cred pushed %ar by %Cgreen%an%Creset%Cred:%Creset%n\"%s\"%n' 2> /dev/null":log
	{
		alias "${CMD/*:}"="git --no-pager ${CMD%:*} 2> /dev/null"

		# Use this instead, if you want pager support:
		#alias "${CMD/*:}"="git ${CMD%:*} 2> /dev/null"
	}
fi

# If you have gvfs-trash available, be safe with that.
if type -fP gvfs-trash > /dev/null 2>&1; then
	alias rm="gvfs-trash" #: Use gvfs-trash in place of rm, if available.
fi

# Ease-of-use youtube-dl aliases; these save typing!
if type -fP youtube-dl > /dev/null 2>&1; then
	alias ytdl-video="youtube-dl -c --no-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube, using youtube-dl.
	alias ytdl-audio="youtube-dl -cx --no-playlist --audio-format mp3 --sleep-interval 5 --max-sleep-interval 30 --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube, using youtube-dl.
	alias ytpldl-audio="youtube-dl -cix --audio-format mp3 --sleep-interval 5 --yes-playlist --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube playlist, using youtube-dl.
	alias ytpldl-video="youtube-dl -ci --yes-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube playlist, using youtube-dl.
fi

# Various [q]uick apt-cache aliases to make life easier still.
if type -fP apt-cache > /dev/null 2>&1; then
	for CMD in qse:"search" qsh:"show"; {
		alias ${CMD%:*}="apt-cache ${CMD/*:}" #: ???
	}
fi

# Workaround for older versions of dd; displays progress.
if type -fP dd pidof > /dev/null 2>&1; then
	alias ddp="kill -USR1 `pidof dd`" #: Workaround for older versions of dd; displays progress.
fi

# These are just options I find the most useful when using dmesg.
if type -fP dmesg > /dev/null 2>&1; then
	alias klog="dmesg -t -L=never -l err,crit,alert,emerg" #: Potentially useful option for viewing the kernel log.
fi

# Enable the default hostkey when vboxsdl is used, if virtualbox gui is not found.
if type -fP vboxsdl > /dev/null 2>&1 && ! type -fP virtualbox > /dev/null 2>&1; then
	alias vboxsdl="vboxsdl --hostkey 305 128" #: Enable the default hostkey when only vboxsdl is found.
fi

# Clear the clipboard using xclip.
if type -fP xclip > /dev/null 2>&1; then
	alias ccb='for X in "-i" "-i -selection clipboard"; { printf "%s" "" | xclip $X}' #: Clear the clipboard using xclip.
fi

# Get more functionality by default when using grep and ls.
if type -fP ls grep > /dev/null 2>&1; then
	case "${TERM:-EMPTY}" in
			linux|xterm|xterm-256color)
				alias ls="ls --quoting-style=literal -nphq --time-style=iso --color=auto --group-directories-first --show-control-chars" #: A stylish, informative alternative to the 'ls' standard.
				alias lsa="ls -A" #: As the previously set 'ls' alias, but show all files.
				alias grep="grep --color=auto" #: Colorful (auto) 'grep' output.
			;;
	esac
fi

# Quick navigation aliases in absence of the autocd shell option.
if ! shopt -qp autocd; then
	alias ~="cd $HOME" #: ???
	alias ..="cd .." #: ???
fi

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
if type -fP ls eject > /dev/null 2>&1 && [ -b /dev/sr0 ]; then
	for DEV in /dev/sr[0-9]*; {
		alias ot${DEV/\/dev\/sr}="eject $DEV"
		alias ct${DEV/\/dev\/sr}="eject -t $DEV"

		if type -fP udisksctl > /dev/null 2>&1; then
			alias mcd${DEV/\/dev\/sr}="udisksctl mount -b $DEV"
			alias umcd${DEV/\/dev\/sr}="udisksctl unmount -b $DEV"
		fi
	}
fi

# These aliases save a lot of typing and do away with the output.
if type -fP mplayer > /dev/null 2>&1; then
	# If you're having issues with mpv/mplayer here, try -vo x11 instead.
	alias mpa="mplayer -nolirc -vo null -really-quiet > /dev/null 2>&1" #: Use 'mplayer' to play audio files, sans window or output.

	declare -a MPLAYER_FONT=("-font" "$HOME/.mplayer/subfont.ttf")
	if ! [ -f "${MPLAYER_FONT[0]}" ] || ! [ -r "${MPLAYER_FONT[0]}" ]; then
		unset MPLAYER_FONT
	fi

	alias mpv="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet > /dev/null 2>&1" #: Use 'mplayer' to play video files, sans output.
	alias mpvdvd="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet dvd://1//dev/sr1 > /dev/null 2>&1" #: Use 'mplayer' to play DVDs, sans output.
elif type -fP mpv > /dev/null 2>&1; then
	#alias mpvve="mpv --af=equalizer=8:7:6:5:0:6:0:5:5:5 --no-stop-screensaver > /dev/null 2>&1 "
	alias mpvv="mpv --no-stop-screensaver > /dev/null 2>&1 " #: Use 'mpv' to play video files, sans output.
fi

if type -fP lsblk > /dev/null 2>&1; then
	alias lsblkid='lsblk -o name,label,fstype,size,uuid,mountpoint --noheadings' #: A more descriptive, yet concise lsblk.
fi

if type -fP pager > /dev/null 2>&1 || type -fP less > /dev/null 2>&1; then
	alias pager='pager -sN --tilde' #: Useful options included with 'pager'.
	alias less='pager -sN --tilde' #: Useful options included with 'less'.

	# Text files I occasionally like to view, but not edit.
	if type -fP pager > /dev/null 2>&1; then
		for FILE in\
		\
			"/var/log/apt/history.log":aptlog\
			"$HOME/Documents/TT/python/Module\ Index.txt":pymodindex;
		{
			if [ -f "${FILE%:*}" -a -r "${FILE%:*}" ]; then
				alias ${FILE/*:}="pager ${FILE%:*}"
			fi
		}
	fi
fi


if type -fP vim > /dev/null 2>&1; then
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
		alias ${FILE/*:}="vim $HOME/${FILE%:*}"
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
		alias ${FILE/*:}="rvim ${FILE%:*}"
	}
fi

# When in a TTY, change to different ones.
if [[ `tty` == /dev/tty* ]] && type -fP tty chvt > /dev/null 2>&1; then
	for TTY in {1..12}; {
		alias $TTY="chvt $TTY"
	}
fi

	if type -fP evince > /dev/null 2>&1; then
	alias pdf="evince > /dev/null 2>&1" #: Use 'evince' to display PDF documents.
fi

# Clean up functions and variables.
unset -f FOR_THE_EDITOR
unset DEP FILE DEPCOUNT FOR_THE_EDITOR TTDIR DIR CHOSEN_EDITOR GIT

