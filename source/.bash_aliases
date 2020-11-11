#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_aliases
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Sat  7 Nov 00:18:51 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# IMPORTANT: If you use `lad`, you need to read the contents of `lad --help`
#            before making any changes to this file, or risk breaking it's
#            functionality.
#------------------------------------------------------------------------------

# Just in-case.
[ "$BASH_VERSION" ] || return 1

# Nifty trick to allow aliases to work with sudo. This avoids needing sudo in
# these configuration files, since using sudo in scripts is not great.
alias sudo="sudo " #: Allows for aliases to work with sudo.

if type -fP sh &> /dev/null; then
	alias uplinks='cd "$HOME/GitHub/terminalforlife/Personal" && for File in {Extra,BashConfig,i3Config,VimConfig}/devutils/links.sh; { sh "$File"; }; cd -' #: Personal scripts for updating my GitHub-related hard links.
fi

if [ -f /sys/class/power_supply/BAT1/capacity ]; then
	alias bat='read < /sys/class/power_supply/BAT1/capacity; printf "Battery is at %d%% capacity.\n" "$REPLY"' #: Output the percentage of battery power remaining.
fi

if type -fP dpkg-query &> /dev/null; then
	alias getsecs='awk "!Z[\$1]++" <<< "$(dpkg-query -Wf "\${Section}\\n" "*")" | column' #: List Debian package sections, per installed packages.
fi

if type -fP yash &> /dev/null; then
	alias sh='yash -o posixlycorrect' #: Instead of executing dash, go for the more POSIX-compliant yash.
fi

if type -fP df &> /dev/null; then
	alias df='df -x devtmpfs -x tmpfs -x usbfs' #: More relevant output than the default.
fi

if type -fP perl &> /dev/null; then
	alias perl-lib-path="perl -e 'print(\"\$_\n\") foreach @INC'" #: List directories in which Perl looks for library files.
fi

# Display a list of all of the currently available font families.
if type -fP fc-list &> /dev/null; then
	alias lsfont="fc-list : family" #: List all of the currently available font families.
fi

# View the entire (17,000+ lines) Vim User Guide.
if type -fP cat less &> /dev/null; then
	alias vug='cat /usr/share/vim/vim74/doc/usr_*.txt | less -nrs' #: View the entire Vim User Guide.
fi

# A useful file to edit, if you use the X Display Manager.
if [ -f /etc/X11/xdm/Xresources ] && type -fP xdm &> /dev/null; then
	alias xdm-xresources='rvim /etc/X11/xdm/Xresources' #: Useful file to edit if you use the X Display Manager.
fi

# A less excessive, yet still very useful current-user-focused ps command.
if type -fP ps &> /dev/null; then
	alias ps='ps -faxc -U $UID -o pid,uid,gid,pcpu,pmem,stat,comm' #: Less excessive, current-user-focused ps alternative.
fi

# I'm done with the boring original apt-get output! I'm also sick of specifying
# --purge --autoremove, so I want it to be assumed! A much more useful apt-get.
if type -fP apt-get &> /dev/null; then
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

	alias apt-get='apt-get --quiet -o Dpkg::Progress=true -o Dpkg::Progress-Fancy=true -o APT::Get::AutomaticRemove=true ' #: Much nicer output for the apt-get command.
fi

# Quick alias to clear out some junk from HOME.
if type -fP rm &> /dev/null; then
	PLACES=(\
		"$HOME/.cache"
		"$HOME/.thumbnails"
		"$HOME/.mozilla/firefox/Crash\ Reports"
		"$HOME/.mozilla/firefox/Pending\ Pings"
	)

	alias hsh="rm --interactive=never -rv ${PLACES[@]} 2> /dev/null" #: Clear out some junk from the current user's HOME.

	# Add verbosity to various important commands.
	alias rm='rm -v'
	alias mv='mv -v'
	alias mkdir='mkdir -v'
	alias cp='cp -v'
	alias ln='ln -v'
	alias chown='chown -v'
	alias chmod='chmod -v'
	alias rmdir='rmdir -v'

	# Fix all CWD file and directory permissions to match the safer 0077 umask.
	# The GitHub directory (/home/$USER/GitHub/) and its contents are protected
	# from this, as it could cause quite the problem.
	if type -fP chmod find &> /dev/null; then
		alias fixperms='[[ $PWD == "$HOME/GitHub/"* ]] || find -xdev -not -path "*/GitHub/*" \( -type f -exec chmod 600 {} \+ -o -type d -exec chmod 700 "{}" \+ \) -exec chown $UID:$UID {} \+ -printf "FIXING: %p\n" 2> /dev/null' #: Recursively fix permissions and ownership. (F:600 D:700, UID:UID)

		if type -fP sync systemctl sleep &> /dev/null; then
			alias shutdown='cd "$HOME"; hsh; fixperms; sync; sleep 3s; systemctl poweroff' #: Perform some standard maintenance tasks, then shutdown.
		fi
	fi
fi

# Make the ffmpeg output less cluttered, but also ignore many errors.
if type -fP ffmpeg &> /dev/null; then
	alias ffmpeg="ffmpeg -v 0 -stats" #: De-clutter this program's output, but not entirely.
fi

# Notify you of a job completion on the terminal. I use this with dunst.
if type -fP notify-send tty &> /dev/null; then
	# Standard notification.
	alias yo='notify-send --urgency=normal "Your normal job in `tty` has completed."' #: Perform a standard notify-send notification.

	# Urgent notification.
	alias YO='notify-send --urgency=critical "Your critical job in `tty` has completed."' #: Perform an urgent notify-send notification.
fi

# Used to use gpicview, until I realised feh could be used as an image viewer!
if type -fP feh &> /dev/null; then
	if type -fP wget &> /dev/null; then
		alias getsetwall='wget -qO - "https://source.unsplash.com/random/1920x1080" | feh --bg-center -' #: Fetch and set a random 1920x1080 wallpaper.
		alias get='wget -qc --show-progress' #: Download with wget, using some tidier settings with -c.
	fi

	alias img='feh --fullscreen --hide-pointer --draw-filename --no-menus --preload 2> /dev/null' #: Slide-show images in current directory using feh.
fi

# Quickly flash the terminal and sound the bell 3 times.
if type -fP sleep &> /dev/null; then
	alias alertme='for I in {1..3}; { sleep 0.03s; printf "\a\e[?5h"; sleep 0.03s; printf "\a\e[?5l"; }' #: Sound the bell and flash the terminal (white) thrice.
fi

# Remove trailing spaces or lines with only spaces. Tabs included. Needs testing.
if type -fP sed &> /dev/null; then
	alias nospace='sed s/[\ \\t]\\+$//' #: Clear trailing spaces from given file(s).
	alias nospacei='sed -i s/[\ \\t]\\+$//' #: Destructively clear trailing spaces from file(s).
fi

# Efficient and fairly portable way to display the current iface, using 'ip'.
if type -fP ip &> /dev/null; then
	alias iface='X=(`ip route`) && printf "%s\n" ${X[4]}' #: Display the current iface, using the 'ip' command.
fi

if type -fP hddtemp &> /dev/null; then
	alias temphdd='hddtemp /dev/sd{a..z} 2> /dev/null' #: View all sd* storage device temperatures.
fi

if [ -f /var/log/boot.log ]; then
	alias bootlog='while read -r; do printf "%s\n" "$REPLY"; done < /var/log/boot.log' #: View the system boot log, with colors.
fi

if type -fP newsbeuter &> /dev/null; then
	alias news='newsbeuter -qr -c "$HOME/.newsbeuter/cache.db" -u "$HOME/.newsbeuter/urls" -C "$HOME/.newsbeuter/newsbeuter.conf"' #: Load newsbeuter more quickly to get access to RSS feeds.
	alias rss='vim $HOME/.newsbeuter/urls' #: Edit a list of RSS feeds, using Vim.
fi

# Watches a directory as its size and number of files increase. Useful while
# you're downloading or making other changes to its contents, and wanna watch.
if type -fP ls watch &> /dev/null; then
	alias dwatch='watch -n 0.1 -t "ls -SsCphq --color=auto --group-directories-first"' #: Watche a directory for changes in size and number of files.
fi

# Create or unmount a user-only RAM Disk (tmpfs, basically) of 32MB.
if type -fP mount umount &> /dev/null; then
	RAMDISK="/media/$USER/RAMDisk_32M"

	alias rd='mount -t tmpfs tmpfs -o x-mount.mkdir=700,uid=1000,gid=1000,mode=700,nodev -o noexec,nosuid,size=32M "$RAMDISK"' #: Create a user-only RAM Disk (tmpfs) of 32MB.
	alias nord='sh -c umount\ "$RAMDISK"\ \&\&\ rmdir\ "$RAMDISK"' #: Remove a RAM Disk created with the 'rd' alias.
fi

# Enable a bunch of git aliases, if you have git installed.
if type -fP git &> /dev/null; then
	for CMD in\
	\
		"remote add upstream":raddup "rm":grm "add":add "tag":tag\
		"push":push "pull":pull "pull upstream":pup "diff":diff\
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

	alias pulltfl='for Dir in "$HOME/GitHub/terminalforlife/Personal"/*; { [ -d "$Dir" ] || continue; cd "$Dir" && pull "$Dir"; cd ..; }' #: Personal alias to pull all `Personal` repositories.
fi

# Ease-of-use youtube-dl aliases; these save typing!
if type -fP youtube-dl &> /dev/null; then
	alias ytdl-video="youtube-dl -c --no-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube, using youtube-dl.
	alias ytdl-audio="youtube-dl -cx --no-playlist --audio-format mp3 --sleep-interval 5 --max-sleep-interval 30 --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube, using youtube-dl.
	alias ytpldl-audio="youtube-dl -cix --audio-format mp3 --sleep-interval 5 --yes-playlist --no-call-home --console-title --quiet --ignore-errors" #: Download HQ videos from YouTube playlist, using youtube-dl.
	alias ytpldl-video="youtube-dl -ci --yes-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors" #: Download HQ audio from YouTube playlist, using youtube-dl.
fi

# These are just options I find the most useful when using dmesg.
if type -fP dmesg &> /dev/null; then
	alias klog="dmesg -t -L=never -l err,crit,alert,emerg" #: Potentially useful option for viewing the kernel log.
fi

# Clear the clipboard (both types) using xclip.
if type -fP xclip &> /dev/null; then
	alias ccb='for X in "-i" "-i -selection clipboard"; { printf "%s" "" | xclip $X; }' #: Clear the clipboard using xclip.
fi

# Get more functionality by default when using grep and ls.
if type -fP ls grep &> /dev/null; then
	case "${TERM:-EMPTY}" in
			linux|xterm|xterm-256color)
				alias ls='ls --quoting-style=literal -pq --time-style=iso --color=auto --group-directories-first --show-control-chars' #: A presentable but minimalistic 'ls'.
				alias lsa='ls -A' #: As 'ls', but also show all files.
				alias lsl='ls -nph' #: As 'ls', but with lots of information.
				alias lsla='ls -Anph' #: As 'lsl', but also show all files.
				alias grep='grep -sI --color=auto' #: Colorful (auto) 'grep' output.
			;;
	esac
fi

# Quick navigation aliases in absence of the autocd shell option.
if ! shopt -qp autocd; then
	alias ~="cd $HOME" #: ???
	alias ..="cd .." #: ???
fi

# For each directory listed to the left of `:`, create an alias you see on the
# right of `:`. This is a key=value style approach, like dictionaries in
# Python. HOME only.
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

# When dealing with udisksctl or mount, these are very useful!
if [ -d "/media/$USER" ]; then
	alias sd="cd /media/$USER" #: Change the CWD to: /media/$USER
else
	alias mnt='cd /mnt' #: Change the CWD to: /mnt
fi

# For each found "sr" device, enables alias for opening and closing the tray.
# For example, use to to specific you want the tray for `/dev/sr0` to open.
# Testing for `/dev/sr0` to ensure >= 1 device is available, to avoid errors.
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
	# If you're having issues with mpv/mplayer here, try -vo x11 instead.
	alias mpa='mplayer -nolirc -vo null -really-quiet &> /dev/null' #: Use 'mplayer' to play audio files, sans window or output.

	declare -a MPLAYER_FONT=('-font' "$HOME/.mplayer/subfont.ttf")
	if ! [ -f "${MPLAYER_FONT[0]}" ] || ! [ -r "${MPLAYER_FONT[0]}" ]; then
		unset MPLAYER_FONT
	fi

	alias mpv="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet &> /dev/null" #: Use 'mplayer' to play video files, sans output.
	alias mpvdvd="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet dvd://1//dev/sr1 &> /dev/null" #: Use 'mplayer' to play DVDs, sans output.
elif type -fP mpv &> /dev/null; then
	alias mpvv='mpv --no-stop-screensaver &> /dev/null ' #: Use 'mpv' to play video files, sans output.
fi

if type -fP lsblk &> /dev/null; then
	alias lsblkid='lsblk -o name,label,fstype,size,uuid,mountpoint --noheadings' #: A more descriptive, yet concise lsblk.
fi

if type -fP pager &> /dev/null || type -fP less &> /dev/null; then
	alias pager='pager -sN --tilde' #: Useful options included with 'pager'.
	alias less='pager -sN --tilde' #: Useful options included with 'less'.

	# Text files I occasionally like to view, but not edit.
	if type -fP pager &> /dev/null; then
		for File in\
		\
			"/var/log/apt/history.log":aptlog\
			"$HOME/Documents/TT/python/Module\ Index.txt":pymodindex;
		{
			if [ -f "${File%:*}" -a -r "${File%:*}" ]; then
				alias ${File/*:}="pager ${File%:*}"
			fi
		}
	fi
fi


if type -fP vim &> /dev/null; then
	# Many files I often edit; usually configuration files.
	for File in\
	\
		'.zshrc':zshrc '.vimrc':vimrc '.bashrc':bashrc\
		'.profile':profile '.config/herbstluftwm/panel.sh':panel\
		'.config/i3/config':i3c 'bin/maintain':maintain-sh\
		'.bash_aliases':bashaliases '.config/compton.conf':compconf\
		'Documents/TT/Useful_Commands':cn 'i3blocks1.conf':i3cb1\
		'.libi3bview':li3bv '.i3babove':i3b2 '.i3bbelow':i3b1\
		'.xbindkeysrc':xbkrc '.bash_functions':bashfunctions\
		'.config/openbox/rc.xml':obc '.dosbox/dosbox-0.74.conf':dbc\
		'.config/herbstluftwm/autostart':hla '.conkyrc':conkyrc\
		'.config/gitsap/config':gitsapconf;
	{
		[ -f "$HOME/${File%:*}" ] || continue
		alias ${File/*:}="vim $HOME/${File%:*}"
	}

	# As above, but for those which need root privileges.
	for File in\
	\
		'/etc/hosts':hosts '/etc/fstab':fstab '/etc/modules':modules\
		'/etc/pam.d/login':pamlogin '/etc/bash.bashrc':bash.bashrc\
		"$HOME/bin/maintain":maintain-sh\
		'/etc/X11/default-display-manager':ddm\
		'/etc/X11/default-display-manager':defdm\
		'/etc/modprobe.d/blacklist.conf':blacklist;
	{
		[ -f "${File%:*}" ] || continue
		alias ${File/*:}="rvim ${File%:*}"
	}

	# Personal alias to list files with tabs, so they can then be converted. I
	# know this can be automated, but I'd like to see it done myself. This is
	# mainly used for my forks of Chubin's 'cheat.sheets' repository on GitHub.
	alias lstabs='gitgrep "	" | awk -F ":" "{!z[\$1]++} END {for(I in z){print(I)}}"'
fi

if type -fP md5sum &> /dev/null; then
	alias chksum='md5sum --ignore-missing --quiet -c 2> /dev/null' #: Check the MD5 hashsums using the provided file.

	if type -fP sort find sed &> /dev/null; then
		alias gitsum='Dir=`git rev-parse --show-toplevel 2> /dev/null` && cd "$Dir" && find -not -path "*.git*" -type f -not -name "README.md" -not -name "LICENSE" -not -name "md5sum" -exec md5sum {} \+ 2> /dev/null | sed "s/\.\///" | sort -k 2 > md5sum; cd - &> /dev/null' #: Lazy solution to saving a sane and sorted checksum list to './md5sum' file.
	fi
fi

# When in a TTY, change to different ones.
if [[ `tty` == /dev/tty* ]] && type -fP tty chvt &> /dev/null; then
	for TTY in {1..12}; {
		alias $TTY="chvt $TTY"
	}
fi
	if type -fP evince &> /dev/null; then
	alias pdf='evince &> /dev/null' #: Use 'evince' to display PDF documents.
fi

# Personal aliases I want only to have enabled if I'm logged in. (rudimentary)
if [ $UID -eq 1000 -a $USER == 'ichy' ]; then
	type -fP mplay &> /dev/null &&
		alias mplay='mplay /media/$USER/Main\ Data/Linux\ Generals/Music'

	if type -fP ssh &> /dev/null; then
		alias ihh='ssh -Cq server :'
		alias chkrf='chkrf server Desktop/READ_ME.txt'
	fi

	[ -f "$HOME/Documents/TT/shotmngr.sh" ] &&
		alias sm="bash $HOME/Documents/TT/shotmngr.sh"
fi

# Clean up functions and variables.
unset File DIR CHOSEN_EDITOR GIT
