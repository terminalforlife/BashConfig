#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_aliases
#----------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Sat 25 Jan 21:23:53 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# IMPORTANT: If you use `lad`, you need to read the contents of `lad --help` before
#            making any changes to this file, or risk breaking it's functionality.
#----------------------------------------------------------------------------------

# Just in-case.
[ "$BASH_VERSION" ] || return 1

alias sudo='sudo ' #: Allows for aliases to work with sudo.

if type -fP dpkg-query &> /dev/null; then
	alias getsecs='awk "!Z[\$1]++" <<< "$(dpkg-query -Wf "\${Section}\\n" "*")" | column' #: List Debian package sections, per installed packages.
fi

if type -fP yash &> /dev/null; then
	alias sh='yash -o posixlycorrect' #: Instead of executing dash, go for the more POSIX-compliant yash.
fi

if type -fP df &> /dev/null; then
	alias df='df -lT -x devtmpfs -x tmpfs -x usbfs' #: More relevant output than the default.
fi

if type -fP perl &> /dev/null; then
	alias perl-lib-path="perl -e 'print(\"\$_\n\") foreach @INC'" #: List directories in which Perl looks for library files.
fi

if type -fP fc-list &> /dev/null; then
	alias lsfont='fc-list : family' #: List all of the currently available font families.
fi

if type -fP cat vim &> /dev/null; then
	alias vug='cat /usr/share/vim/vim74/doc/usr_*.txt | vim -' #: View the entire VIM User Guide.
fi

if [ -f /etc/X11/xdm/Xresources ] && type -fP xdm &> /dev/null; then
	alias vug='cat /usr/share/vim/vim74/doc/usr_*.txt | vim -' #: View the entire VIM User Guide.
	alias xdm-xresources='rvim /etc/X11/xdm/Xresources' #: Useful file to edit if you use the X Display Manager.
fi

if type -fP apt-get &> /dev/null; then
	alias apt-get='apt-get --quiet -o Dpkg::Progress=true -o Dpkg::Progress-Fancy=true -o APT::Get::AutomaticRemove=true -o APT::Get::Purge=true ' #: Much nicer output for the apt-get command.
fi

if type -fP rm &> /dev/null; then
	# Add verbosity to various important commands.
	for Dep in\
	\
		'chmod:-v' 'chown:-v' 'cp:-v' 'killall:-v' 'ln:-v'\
		'mkdir:-v' 'mv:-v' 'rm:-v' 'rmdir:-v' 'pkill:-e';
	{
		alias ${Dep%%:*}="${Dep%%:*} ${Dep##*:}"
	}

	Places=(\
		"$HOME/.cache"
		"$HOME/.thumbnails"
		"$HOME/.mozilla/firefox/Crash Reports"
		"$HOME/.mozilla/firefox/Pending Pings"
	)

	alias hsh="rm -rf ${Places[@]} 2> /dev/null" #: Clear out some junk from the current user's HOME.
fi

if type -fP ffmpeg &> /dev/null; then
	alias ffmpeg="ffmpeg -v 0 -stats" #: De-clutter this program's output, but not entirely.
fi

if type -fP gio &> /dev/null; then
	alias trash='gio trash ' #: Empty the trash with `gio`.
elif type -fP gvfs &> /dev/null; then
	alias trash='gvfs-trash ' #: Empty the trash with `gvfs-trash`.
fi

if [ "$USER" == 'ichy' -a $UID -eq 1000 ]; then
	if [ -f "$HOME/Documents/TT/shotmngr.sh" ]; then
		alias sm='bash $HOME/Documents/TT/shotmngr.sh' #: Personal script for managing screenshots.
	fi

	if type -fP ssh &> /dev/null; then
		alias svr='sh "$HOME/Documents/TT/svrcon"' #: Personal script to connect or copy to a remote server.
	fi
fi

if type -fP notify-send tty &> /dev/null; then
	alias yo='notify-send --urgency=normal "Your normal job in `tty` has completed."' #: Perform a standard notify-send notification.
	alias YO='notify-send --urgency=critical "Your critical job in `tty` has completed."' #: Perform an urgent notify-send notification.
fi

if type -fP feh &> /dev/null; then
	if type -fP wget &> /dev/null; then
		alias getsetwall='wget -qO - "https://source.unsplash.com/random/1920x1080" | feh --bg-center -' #: Fetch and set a random 1920x1080 wallpaper.
		alias get='wget -qc --show-progress' #: Download with wget, using some tidier settings with -c.
	fi

	alias img='feh --fullscreen --hide-pointer --draw-filename --no-menus --preload 2> /dev/null' #: Slide-show images in current directory using feh.

	if [ -n "$SSH_TTY" ] && type -fP scrot &> /dev/null; then
		alias screenlook='{ DISPLAY=:0 scrot -zq 100 /tmp/_.jpg && feh /tmp/_.jpg; } && rm -f /tmp/_.jpg'
	fi
fi

if type -fP sleep &> /dev/null; then
	alias alertme='for I in {1..3}; { sleep 0.03s; printf "\a\e[?5h"; sleep 0.03s; printf "\a\e[?5l"; }' #: Sound the bell and flash the terminal (white) thrice.
fi

if type -fP ip &> /dev/null; then
	alias iface='X=(`ip route`) && printf "%s\n" ${X[4]}' #: Display the current iface, using the 'ip' command.
fi

if [ -f /var/log/boot.log ]; then
	alias bootlog='while read -r; do printf "%s\n" "$REPLY"; done < /var/log/boot.log' #: View the system boot log, with colors.
fi

if type -fP newsbeuter &> /dev/null; then
	alias news='newsbeuter -qr -c "$HOME/.newsbeuter/cache.db" -u "$HOME/.newsbeuter/urls" -C "$HOME/.newsbeuter/newsbeuter.conf"' #: Load newsbeuter more quickly to get access to RSS feeds.
	alias rss='vim $HOME/.newsbeuter/urls' #: Edit a list of RSS feeds, using VIM.
fi

if type -fP ls watch &> /dev/null; then
	alias dwatch='watch -n 0.1 -t "ls -SsCphq --color=never --group-directories-first"' #: Watch a directory for changes in size and number of files.
fi

if type -fP chmod &> /dev/null; then
	alias fixperms='[[ "$PWD" == "/home/$USER/GitHub/"* ]] || find -xdev -not -path "*/GitHub/*" \( -type f -exec chmod 600 {} \+ -o -type d -exec chmod 700 "{}" \+ \) -exec chown $UID:$UID {} \+ -printf "FIXING: %p\n" 2> /dev/null' #: Recursively fix permissions and ownership. (F:600 D:700, UID:UID)
fi

if type -fP mount umount &> /dev/null; then
	RAMDISK="/media/$USER/RAMDisk_32M"

	alias rd='mount -t tmpfs tmpfs -o x-mount.mkdir=700,uid=1000,gid=1000,mode=700,nodev -o noexec,nosuid,size=32M "$RAMDISK"' #: Create a user-only RAM Disk (tmpfs) of 32MB.
	alias nord='sh -c umount\ "$RAMDISK"\ \&\&\ rmdir\ "$RAMDISK"' #: Remove a RAM Disk created with the 'rd' alias.
fi

if type -fP git &> /dev/null; then
	for CMD in\
	\
		'add':add\
		'branch':branch\
		'checkout':checkout\
		'clone':clone\
		'commit -m':scommit\
		'commit':commit\
		'config --list':gcl\
		'config':config\
		'describe --long --tag':describe\
		'diff':diff\
		'init':init\
		"log --reverse --pretty=format:'%CredCommit %Cgreen%h%Cred pushed %ar by %Cgreen%an%Creset%Cred:%Creset%n\"%s\"%n' 2> /dev/null":log\
		'merge':merge\
		'mv':gmv\
		'pull upstream':pullup\
		'pull':pull\
		'push':push\
		'remote add upstream':raddup\
		'rm --cached':grmc\
		'rm':grm\
		"show --pretty=format:'%CredCommit %Cgreen%h%Cred pushed %ar by %Cgreen%an%Creset%Cred:%Creset%n\"%s\"%n'":show\
		'status -s':status\
		'tag':tag;
	{
		alias "${CMD/*:}"="git --no-pager ${CMD%:*} 2> /dev/null"
	}
fi

if type -fP youtube-dl &> /dev/null; then
	alias ytdl-video="youtube-dl -c --no-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube, using youtube-dl.
	alias ytdl-audio="youtube-dl -cx --no-playlist --audio-format mp3 --sleep-interval 5 --max-sleep-interval 30 --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube, using youtube-dl.
	alias ytpldl-audio="youtube-dl -cix --audio-format mp3 --sleep-interval 5 --yes-playlist --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube playlist, using youtube-dl.
	alias ytpldl-video="youtube-dl -ci --yes-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube playlist, using youtube-dl.
fi

if type -fP apt-cache &> /dev/null; then
	for CMD in qse:"search" qsh:"show"; {
		alias ${CMD%:*}="apt-cache ${CMD/*:}" #: ???
	}
fi

if type -fP dd pidof &> /dev/null; then
	alias ddp="kill -USR1 `pidof dd`" #: Workaround for older versions of dd; displays progress.
fi

if type -fP dmesg &> /dev/null; then
	alias klog="dmesg -t -L=never -l err,crit,alert,emerg" #: Potentially useful option for viewing the kernel log.
fi

if type -fP vboxsdl &> /dev/null && ! type -fP virtualbox &> /dev/null; then
	alias vboxsdl="vboxsdl --hostkey 305 128" #: Enable the default hostkey when only vboxsdl is found.
fi

if type -fP xclip &> /dev/null; then
	alias ccb='for X in "-i" "-i -selection clipboard"; { printf "%s" "" | xclip $X; }' #: Clear the clipboard using xclip.
fi

if type -fP ls grep &> /dev/null; then
	case "${TERM:-EMPTY}" in
			linux|xterm|xterm-256color)
				alias ls="ls --quoting-style=literal -pq --time-style=iso --color=auto --group-directories-first --show-control-chars" #: A presentable but minimalistic 'ls'.
				alias lsa="ls -A" #: As 'ls', but also show all files.
				alias lsl="ls -nph" #: As 'ls', but with lots of information.
				alias lsla="ls -Anph" #: As 'lsl', but also show all files.
				alias grep="grep -sI --color=auto" #: Colorful (auto) 'grep' output.
			;;
	esac
fi

if ! shopt -qp autocd; then
	alias ~="cd $HOME" #: ???
	alias ..="cd .." #: ???
fi

for DIR in\
\
	'Music':mus 'GitHub':gh 'Videos':vid 'Desktop':dt 'Pictures':pic\
	'Downloads':dl 'Documents':doc 'Documents/TT':tt '.shplugs':sp\
	'GitHub/terminalforlife':ghtfl 'GitHub/terminalforlife/Forks':ghtflf\
	'GitHub/terminalforlife/Personal':ghtflp 'DosBox':db 'Archives':arc\
	'.i3a':i3a 'LearnLinux':ll;
{
	[ -d "$HOME/${DIR%:*}" ] && alias ${DIR/*:}="cd $HOME/${DIR%:*}"
}

if [ -d "/media/$USER" ]; then
	alias sd="cd /media/$USER" #: Change the CWD to: /media/$USER
else
	alias mnt='cd /mnt' #: Change the CWD to: /mnt
fi

if type -fP ls eject &> /dev/null && [ -b /dev/sr0 ]; then
	for DEV in /dev/sr[0-9]*; {
		alias ot${DEV/\/dev\/sr}="eject $DEV"
		alias ct${DEV/\/dev\/sr}="eject -t $DEV"

		if type -fP udisksctl &> /dev/null; then
			alias mcd${DEV/\/dev\/sr}="udisksctl mount -b $DEV"
			alias umcd${DEV/\/dev\/sr}="udisksctl unmount -b $DEV"
		fi
	}
fi

if type -fP mplayer &> /dev/null; then
	alias mpa='mplayer -nolirc -vo null -really-quiet &> /dev/null' #: Use 'mplayer' to play audio files, sans window or output.

	declare -a MplayerFont=("-font" "$HOME/.mplayer/subfont.ttf")
	[ -f "${MplayerFont[0]}" -a -r "${MplayerFont[0]}" ] || unset MplayerFont

	alias mpv="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MplayerFont -really-quiet &> /dev/null" #: Use 'mplayer' to play video files, sans output.
	alias mpvdvd="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MplayerFont -really-quiet dvd://1//dev/sr1 &> /dev/null" #: Use 'mplayer' to play DVDs, sans output.
elif type -fP mpv &> /dev/null; then
	alias mpvv='mpv --no-stop-screensaver &> /dev/null ' #: Use 'mpv' to play video files, sans output.
fi

if type -fP lsblk &> /dev/null; then
	alias lsblkid='lsblk -o name,label,fstype,size,uuid,mountpoint --noheadings' #: A more descriptive, yet concise lsblk.
fi

if type -fP pager &> /dev/null || type -fP less &> /dev/null; then
	alias pager='pager -sN --tilde' #: Useful options included with 'pager'.
	alias less='pager -sN --tilde' #: Useful options included with 'less'.

	if type -fP pager &> /dev/null; then
		for CurFile in\
		\
			'/var/log/apt/history.log':aptlog\
			"$HOME/Documents/TT/python/Module\ Index.txt":pymodindex;
		{
			if [ -f "${CurFile%:*}" -a -r "${CurFile%:*}" ]; then
				alias ${CurFile/*:}="pager ${CurFile%:*}"
			fi
		}
	fi
fi


if type -fP vim &> /dev/null; then
	for CurFile in\
	\
		'.bash_aliases':bashaliases\
		'.bash_functions':bashfunctions\
		'.bashrc':bashrc\
		'.config/compton.conf':compconf\
		'.config/herbstluftwm/autostart':hla\
		'.config/herbstluftwm/panel.sh':panel\
		'.config/i3/config':i3c\
		'.config/openbox/rc.xml':obc\
		'.conkyrc':conkyrc\
		'.dosbox/dosbox-0.74.conf':dbc\
		'.i3babove':i3b2\
		'.i3bbelow':i3b1\
		'.libi3bview':li3bv\
		'.maintain/changelog.txt':maintain-cl\
		'.maintain/maintain.man':maintain-man\
		'.maintain/usersettings.conf':maintain-set\
		'.profile':profile\
		'.vimrc':vimrc\
		'.wgetrc':wgetrc\
		'.xbindkeysrc':xbkrc\
		'.zshrc':zshrc\
		'Documents/TT/Useful_Commands':cn\
		'Documents/TT/python/Useful_Commands.py':cnp\
		'bin/maintain':maintain-sh\
		'i3blocks1.conf':i3cb1;
	{
		[ -f "$HOME/${CurFile%:*}" ] || continue
		alias ${CurFile/*:}="vim $HOME/${CurFile%:*}"
	}

	for CurFile in\
	\
		"$HOME/bin/maintain":maintain-sh\
		'/etc/X11/default-display-manager':ddm\
		'/etc/X11/default-display-manager':defdm\
		'/etc/bash.bashrc':bash.bashrc\
		'/etc/fstab':fstab\
		'/etc/hosts':hosts\
		'/etc/modprobe.d/blacklist.conf':blacklist\
		'/etc/modules':modules\
		'/etc/pam.d/login':pamlogin;
	{
		[ -f "${CurFile%:*}" ] || continue
		alias ${CurFile/*:}="rvim ${CurFile%:*}"
	}
fi

if type -fP md5sum &> /dev/null; then
	alias chksum='md5sum --ignore-missing --quiet -c 2> /dev/null' #: Check the MD5 hashsums using the provided file.
	alias setsum='md5sum 2> /dev/null > ./md5sum' #: Lazy solution to saving checksums to './md5sum' file.
fi

case `tty` in
	/dev/tty*)
		if type -fP tty chvt &> /dev/null; then
			for TTY in {1..12}; { alias $TTY="chvt $TTY"; }
		fi ;;
esac

if type -fP evince &> /dev/null; then
	alias pdf='evince &> /dev/null' #: Use 'evince' to display PDF documents.
fi

unset TTY File MplayerFont Places Dep
