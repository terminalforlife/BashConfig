#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.bash_aliases
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.bash_aliases
# Started On        - Thu 14 Sep 13:14:36 BST 2017
# Last Change       - Fri 10 Sep 13:01:52 BST 2021
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# IMPORTANT: If you use `lad`, you need to read the contents of `lad --help`
#            before making any changes to this file, or risk breaking it's
#            functionality.
#------------------------------------------------------------------------------

[ "$BASH_VERSION" ] || return 1

alias sudo="sudo " #: Allows for aliases to work with sudo(8).
alias hsh='bash $HOME/Documents/TT/bin/sweep'
alias lenchk='bash "$HOME"/GitHub/terminalforlife/Forks/cheat.sheets/tests/lenchk' #: Tester tool I wrote for Chubin's cheat.sh project on GitHub.
alias shortcd='for I in {30..0}; { { espeak -a 50 -s 300 -p 0 "$I" & sleep 1; } &> /dev/null; }' #: Make espeak(1) count down from 30s; was thinking of using this for YouTube.
alias uplinks='cd "$HOME/GitHub/terminalforlife/Personal" && for File in {Extra,BashConfig,i3Config,VimConfig}/devutils/links.sh; { sh "$File"; }; cd -' #: Personal scripts for updating my GitHub-related hard links.
alias bat='read < /sys/class/power_supply/BAT1/capacity; printf "Battery is at %d%% capacity.\n" "$REPLY"' #: Output the percentage of battery power remaining.
alias getsecs='awk "!Z[\$1]++" <<< "$(dpkg-query -Wf "\${Section}\\n" "*")" | column' #: List Debian package sections, per installed packages.
alias psf='ps -faxc -U $UID -o pid,uid,gid,pcpu,pmem,stat,comm' #: Less excessive, current-user-focused ps alternative.
alias apt-get='apt-get -q -o Dpkg::Progress=true -o Dpkg::Progress-Fancy=true -o APT::Get::AutomaticRemove=true ' #: Much nicer output for the apt-get command.
alias rm='rm -v'
alias mv='mv -v'
alias mkdir='mkdir -v'
alias cp='cp -v'
alias ln='ln -v'
alias chown='chown -v'
alias chmod='chmod -v'
alias rmdir='rmdir -v'
#alias fixperms='[[ $PWD == "$HOME/GitHub/"* || $PWD == "$HOME/.steam/"* ]] || find -xdev -not -path "*/GitHub/*" \( -type f -exec chmod 600 {} \+ -o -type d -exec chmod 700 "{}" \+ \) -exec chown $UID:$UID {} \+ -printf "FIXING: %p\n" 2> /dev/null' #: Recursively fix permissions and ownership. (F:600 D:700, UID:UID)
alias ffmpeg="ffmpeg -v 0 -stats" #: De-clutter this program's output, but not entirely.
alias yo='notify-send --urgency=normal "Your normal job in `tty` has completed."' #: Perform a standard notify-send notification.
alias YO='notify-send --urgency=critical "Your critical job in `tty` has completed."' #: Perform an urgent notify-send notification.
alias img='feh --fullscreen --hide-pointer --draw-filename --no-menus 2> /dev/null' #: Slide-show images in current directory using feh.
alias get='wget -qc --show-progress' #: Download with WGet with pretty and useful features.
alias joke='wget -U "curl/7.55.1" -qO - https://icanhazdadjoke.com; printf "\n"' #: Output a random joke from the web.
alias alertme='for I in {1..3}; { sleep 0.03s; printf "\a\e[?5h"; sleep 0.03s; printf "\a\e[?5l"; }' #: Sound the bell and flash the terminal (white) thrice.
alias dwatch='watch -n 0.1 -t "ls -SsCphq --color=auto --group-directories-first"' #: Watche a directory for changes in size and number of files.
alias add='git add'
alias checkout='git checkout'
alias pull='git pull'
alias commit='git commit'
alias merge='git merge'
alias branch='git branch'
alias push='git push'
alias diff='git diff'
alias toplevel='cd "$(git rev-parse --show-toplevel)"' #: Change to the top-most level of the current git(1) repository.
alias log="git --no-pager log --reverse --pretty=format:'%CredCommit %Cgreen%h%Cred pushed %ar by %Cgreen%an%Creset%Cred:%Creset%n\"%s\"%n' 2> /dev/null"
alias show="git --no-pager show --pretty=format:'%CredCommit %Cgreen%h%Cred pushed %ar by %Cgreen%an%Creset%Cred:%Creset%n\"%s\"%n'"
alias status='git status -s'
alias pulltfl='for Dir in "$HOME/GitHub/terminalforlife/Personal"/*; { [ -d "$Dir" ] || continue; cd "$Dir" && pull "$Dir"; cd ..; }' #: Personal alias to pull all `Personal` repositories.
alias ytdl-video="youtube-dl -c --no-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors --output '%(title)s.%(ext)s'" #: Download HQ videos from YouTube, using youtube-dl.
alias ytdl-audio="youtube-dl -cx --no-playlist --audio-format mp3 --sleep-interval 5 --max-sleep-interval 30 --no-call-home --console-title --quiet --ignore-errors --output '%(title)s.%(ext)s'" #: Download HQ audio from YouTube, using youtube-dl.
alias ytpldl-audio="youtube-dl -cix --audio-format mp3 --sleep-interval 5 --yes-playlist --no-call-home --console-title --quiet --ignore-errors --output '%(title)s.%(ext)s'" #: Download HQ videos from YouTube playlist, using youtube-dl.
alias ytpldl-video="youtube-dl -ci --yes-playlist --sleep-interval 5 --format best --no-call-home --console-title --quiet --ignore-errors --output '%(title)s.%(ext)s'" #: Download HQ audio from YouTube playlist, using youtube-dl.
alias klog="dmesg -t -L=never -l emerg,alert,crit,err,warn --human --nopager" #: Potentially useful option for viewing the kernel log.
alias ccb='for X in "-i" "-i -selection clipboard"; { printf "%s" "" | xclip $X; }' #: Clear the clipboard using xclip.
alias ls='ls --quoting-style=literal -pq --time-style=iso --color=auto --group-directories-first --show-control-chars' #: A presentable but minimalistic 'ls'.
alias lsa='ls -A' #: As 'ls', but also show all files.
alias lsl='ls -nph' #: As 'ls', but with lots of information.
alias lsla='ls -Anph' #: As 'lsl', but also show all files.
alias grep='grep -sI --color=auto' #: Colorful (auto) 'grep' output.
alias sd="cd /media/$USER" #: Change the CWD to: /media/$USER
alias mnt='cd /mnt' #: Change the CWD to: /mnt
alias lsblkid='lsblk -o name,label,fstype,size,uuid --noheadings' #: A more descriptive, yet concise lsblk.
alias chksum='md5sum --ignore-missing --quiet -c' #: Check the MD5 hashsums using the provided file.

# No longer using this, as of 2021-03-04. Might keep it around, in-case it ever
# becomes useful again, like if I GPG sign any of my checksum files.
#alias gitsum='Dir=`git rev-parse --show-toplevel 2> /dev/null` && cd "$Dir" && find -not -path "*.git*" -type f -not -name "README.md" -not -name "LICENSE" -not -name "md5sum" -exec md5sum {} \+ 2> /dev/null | sed "s/\.\///" | sort -k 2 > md5sum; cd - &> /dev/null' #: Lazy solution to saving a sane and sorted checksum list to './md5sum' file.

alias nonroots='find -not \( -user 0 -or -group 0 \)' #: List any files not owned by or in the group of the root user.
alias dt='cd "$HOME"/Desktop' #: Change to the current user's desktop.
alias dl='cd "$HOME"/Downloads' #: Change to the current user's 'Downloads' directory.
alias ghtflp='cd "$HOME"/GitHub/terminalforlife/Personal' #: Change to the TFL 'Personal' directory.
alias ghtflf='cd "$HOME"/GitHub/terminalforlife/Forks' #: Change to the TFL 'Forks' directory.
alias tt='cd "$HOME"/Documents/TT' #: Change to the 'TT' directory.
alias i3a='cd "$HOME"/.i3a' #: Change to the '.i3a' directory in HOME.
alias jbp='journalctl -b -p 0..4 --no-pager' #: Use journalctl(1) to display anything from 'emerg' to 'warning' since boot.
alias csi3='csi3 "$HOME"/.config/i3/config'
alias msn='while :; do printf "\ec"; snotes | shuf -n 1; printf "\n"; read -n 1 -p "Press any key to continue... "; done' #: Randomly display one entry at a time from shell programming notes.

if type -P mplayer &> /dev/null; then
	# If you're having issues with mpv/mplayer here, try -vo x11 instead.
	alias mpa='mplayer -nolirc -vo null -really-quiet &> /dev/null' #: Use mplayer(1) to play audio files, sans window or output.

	declare -a MPLAYER_FONT=('-font' "$HOME/.mplayer/subfont.ttf")
	if ! [ -f "${MPLAYER_FONT[0]}" ] || ! [ -r "${MPLAYER_FONT[0]}" ]; then
		unset MPLAYER_FONT
	fi

	alias mpv="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet &> /dev/null" #: Use mplayer(1) to play video files, sans output.
	alias mpvdvd="mplayer -vo x11 -nomouseinput -noar -nojoystick -nogui -zoom -nolirc $MPLAYER_FONT -really-quiet dvd://1//dev/sr1 &> /dev/null" #: Use mplayer(1) to play DVDs, sans output.
elif type -P mpv &> /dev/null; then
	alias mpvv='mpv --no-stop-screensaver &> /dev/null ' #: Use 'mpv' to play video files, sans output.
fi

# Personal aliases I want only to have enabled if I'm logged in. (rudimentary)
if [ $UID -eq 1000 -a $USER == 'ichy' ]; then
	alias thumbnail='sh "$HOME/GitHub/terminalforlife/Personal/ChannelFiles/Miscellaneous Scripts/thumbnail-generator.sh"' #: Execute script to generate a YouTube thumbnail for Learn Linux.
	alias mplay='mplay /media/$USER/Main\ Data/Linux\ Generals/Music'
	alias chkrf='ssh cl cat Desktop/READ_ME.txt | less'
	alias todo='vim "$HOME"/Documents/todo.txt'

	if [ -f "$HOME/Documents/TT/shotmngr.sh" ]; then
		alias sm="bash $HOME/Documents/TT/shotmngr.sh"
	fi

	if [ -f "$HOME/Documents/TT/bin/poks" ]; then
		alias poks="sh $HOME/Documents/TT/bin/poks"
	fi
fi

unset File Basename
