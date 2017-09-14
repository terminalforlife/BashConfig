#----------------------------------------------------------------------------------
# Project Name      - $HOME/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Thu 14 Sep 13:53:48 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

if type -P /usr/bin/blkid-lite &> /dev/null
then
	alias blkid="/usr/bin/blkid-lite"
fi

if type -P /usr/{local/bin,bin}/youtube-dl &> /dev/null
then
	alias ytdl-video="/usr/local/bin/youtube-dl -c --yes-playlist\
		--sleep-interval 5 --max-sleep-interval 30 --format best\
		--no-call-home --console-title --quiet --ignore-errors"
	alias ytdl-audio="/usr/local/bin/youtube-dl -cx --audio-format mp3\
		--sleep-interval 5 --max-sleep-interval 30 --no-call-home\
		--console-title --quiet --ignore-errors"
	alias ytpldl-audio="/usr/local/bin/youtube-dl -cx --audio-format mp3\
		--sleep-interval 5 --max-sleep-interval 30 --yes-playlist\
		--no-call-home --console-title --quiet --ignore-errors"
	alias ytpldl-video="/usr/local/bin/youtube-dl -c --yes-playlist\
		--sleep-interval 5 --max-sleep-interval 30 --format best\
		--no-call-home --console-title --quiet --ignore-errors"
fi

if type -P /usr/bin/apt-get &> /dev/null
then
	for CMD in quf:"remove --purge" qufu:"remove --purge --autoremove"\
		   qu:"remove" qa:"autoremove" qi:"install" qri:"reinstall"\
		   qupd:"update" qupg:"upgrade" qdupg:"dist-upgrade"
	{
		alias ${CMD%:*}="/usr/bin/sudo /usr/bin/apt-get ${CMD/*:}"
	}
fi

if type -P /usr/bin/apt-cache &> /dev/null
then
	for CMD in qse:"search" qsh:"show"
	{
		alias ${CMD%:*}="/usr/bin/apt-cache ${CMD/*:}"
	}
fi

if type -P /bin/{dd,pidof} /usr/bin/sudo &> /dev/null
then
	alias ddp="/usr/bin/sudo kill -USR1 `/bin/pidof /bin/dd`"
fi

if type -P /sbin/{modinfo,lsmod} /usr/bin/cut &> /dev/null
then
	alias lsmodd='
		for MOD in `/sbin/lsmod | /usr/bin/cut -d " " -f 1`
		{
			printf "$MOD - "
			/sbin/modinfo -d "$MOD"
		}
	'
fi

if type -P /bin/dmesg &> /dev/null
then
	alias klog="/bin/dmesg -t -L=never -l err,crit,alert,emerg"
fi

if type -P /usr/bin/vboxsdl &> /dev/null
then
	alias vboxsdl="/usr/bin/vboxsdl --hostkey 305 128"
fi

if type -P /usr/bin/xclip &> /dev/null
then
	alias ccb="printf \"\" | /usr/bin/xclip -i"
fi

if type -P /bin/{ls,grep} /usr/bin/pgrep &> /dev/null
then
	case "${TERM:-EMPTY}"
	in
	        linux|xterm|xterm-256color)
	                alias ls="/bin/ls --color=auto --group-directories-first -Np"
	                alias lss="/bin/ls --color=auto --group-directories-first -SNshp"
	                alias grep="/bin/grep --color=auto"
	                alias egrep="/bin/egrep --color=auto"
	                alias fgrep="/bin/fgrep --color=auto"
	                alias pgrep="/usr/bin/pgrep --color=auto" ;;
	        EMPTY|*)
	                alias ls="/bin/ls --color=never --group-directories-first -Np"
	                alias lss="/bin/ls --color=never --group-directories-first -Nshp"
	                alias grep="/bin/grep --color=never"
	                alias egrep="/bin/egrep --color=never"
	                alias fgrep="/bin/fgrep --color=never"
	                alias pgrep="/usr/bin/pgrep --color=auto" ;;
	esac
fi

if ! shopt -qp autocd
then
	alias ~="cd $HOME"
	alias ..="cd .."
fi

for DIR in\
\
	GitHub:gh\
	Music:mus\
	Videos:vid\
	Desktop:dt\
	Pictures:pic\
	Downloads:dl\
	GitHub/terminalforlife:ghtfl\
	Documents:doc ShellPlugins:sp\
	GitHub/terminalforlife/Forks:ghtflf\
	GitHub/terminalforlife/Personal:ghtflp
{
	[ -d "$HOME/${DIR%:*}" ] && alias ${DIR/*:}="cd $HOME/${DIR%:*}"
}

TTDIR="$HOME/Documents/TT"
[ -d $TTDIR ] && alias tt="cd $TTDIR"

if [ -d "/media/$USER" ]
then
	alias sd="cd /media/$USER"
else
	alias mnt="cd /mnt"
fi

if type -P /usr/bin/mplayer &> /dev/null
then
	MPLAYER_FONT="$HOME/.mplayer/subfont.ttf"
	alias mpa="/usr/bin/mplayer -nolirc -vo null -really-quiet &> /dev/null"

	if [ -f "$MPLAYER_FONT" ]
	then
		alias mpv="/usr/bin/mplayer -nolirc -vo x11 -font \"$MPLAYER_FONT\" -really-quie#"
	else
		alias mpv="/usr/bin/mplayer -nolirc -vo x11 -really-quiet &> /dev/null"
	fi
fi

if type -P /usr/bin/{cut,dpkg-query,uniq,column} /bin/grep &> /dev/null
then
	alias lsesspkg='/usr/bin/dpkg-query --show\
		-f="\${Essential} \${Package}\n" \*\
		| /bin/grep "^yes"\
		| /usr/bin/cut -d " " -f 2\
		| /usr/bin/uniq\
		| /usr/bin/column'

	alias lsreqpkg='/usr/bin/dpkg-query --show\
		-f="\${package} \${Priority}\n" \*\
		| /bin/grep " \(required\)\$"\
		| /usr/bin/uniq\
		| /usr/bin/cut -d " " -f 1\
		| /usr/bin/column'

	alias lsoptpkg='/usr/bin/dpkg-query --show\
		-f="\${package} \${Priority}\n" \*\
		| /bin/grep " \(optional\)\$"\
		| /usr/bin/uniq\
		| /usr/bin/cut -d " " -f 1\
		| /usr/bin/column'

	alias lsextpkg='/usr/bin/dpkg-query --show\
		-f="\${package} \${Priority}\n" \*\
		| /bin/grep " \(extra\)\$"\
		| /usr/bin/uniq\
		| /usr/bin/cut -d " " -f 1\
		| /usr/bin/column'
fi

if type -P /usr/bin/links2 &> /dev/null
then
	alias l2="links2 -http.do-not-track 1 -html-tables 1 -html-tables 1\
		-html-numbered-links 1 duckduckgo.co.uk"
fi

if type -P /bin/lsblk &> /dev/null
then
	alias lsblkid="/bin/lsblk -o name,label,fstype,size,uuid,mountpoint"
fi

if type -P /usr/bin/{pager,less} &> /dev/null
then
	alias pager='/usr/bin/pager -sN --tilde'
	alias less='/usr/bin/pager -sN --tilde'
fi

if type -P /usr/bin/pager &> /dev/null
then
	for FILE in\
	\
		"/var/log/boot.log":bootlog\
		"/var/log/apt/history.log":aptlog\
		"$HOME/Documents/TT/python/Module\ Index.txt":pymodindex;
	{
		if [ -f "${FILE%:*}" ] && [ -r "${FILE%:*}" ]
		then
			alias ${FILE/*:}="/usr/bin/pager ${FILE%:*}"
		fi
	}
fi

FOR_THE_EDITOR()
{
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
		"Documents/TT/Useful_Commands":cn\
		".maintain/changelog.txt":maintain-cl\
		".maintain/maintain.man":maintain-man\
		".maintain/usersettings.conf":maintain-set
	{
		[ -f "${FILE%:*}" ] || continue
		alias ${FILE/*:}="$1 $HOME/${FILE%:*}"
	}
}

FOR_THE_EDITOR_R()
{
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

if [[ `/usr/bin/tty` == /dev/tty* ]]
then
	if type -P /usr/bin/tty /bin/chvt &> /dev/null
	then
		for TTY in {1..12}
		{
			alias $TTY="chvt $TTY"
		}
	fi
fi

if type -P /usr/bin/vim &> /dev/null
then
	FOR_THE_EDITOR "vim"

	if [ -z "$SUDO_EDITOR" ]
	then
		FOR_THE_EDITOR_R "/usr/bin/sudo /usr/bin/rvim"
	else
		FOR_THE_EDITOR_R "/usr/bin/sudo -e"
	fi
fi

if type -P /usr/bin/evince &> /dev/null
then
	alias pdf="/usr/bin/evince &> /dev/null"
fi

unset FILE DEPCOUNT FOR_THE_EDITOR SUDO_EDITOR TTDIR DIR
