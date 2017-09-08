# .bashrc file written by: terminalforlife (terminalforlife@yahoo.com)

# Much safer file and directory permissions, as recommended in the RHEL world.
# That's 700 for directories and 600 for files. (drwx------ and -rw-------)
umask 0077

# Enables POSIX mode for bash. Just something I'm messing with right now.
set -o posix

# If appropriate, add $HOME/bin to the PATH variable.
if [ -d "$HOME/bin" ] && ! [[ "$PATH" == */home/$USER/bin* ]]
then
        export PATH="/home/$USER/bin:${PATH}"
fi

# If not running interactively, skip the rest of the file.
[ -z "$BASH_VERSION" ] && return

if type -P /usr/bin/tty &> /dev/null
then
        if [[ `/usr/bin/tty` == /dev/tty+([0-9]) ]]
        then
                export PS1="→  "; export PS2=">  "
                export PS3="-  "; export PS4="+  "
        else
                if type -P /usr/bin/pacat &> /dev/null
                then
                        PROMPT_S="$HOME/.config/i3/Sounds/SND03.wav"
                        PROMPT_SO="--volume 17000 --rate 9000"
                        PROMPT_COMMAND='/usr/bin/pacat $PROMPT_SO "$PROMPT_S" & disown'
                fi  
                                                                                       
                export PS1="➤  "; export PS2=">  "
                export PS3="-  "; export PS4="+  "
        fi  
fi

# I don't use the bash history file for security reasons. This will prepend time information
# to each history item, and will also ignore entries which begin with a space, and duplicates.
HISTCONTROL=ignoreboth; HISTTIMEFORMAT="[%F_%X]: "; HISTSIZE=1000; HISTFILESIZE=0

# Obviously change this as appropriate for your setup. This is where a bash function library
# would reside, or brief scripts like those which contain your set and/or shopt options.
FLIB="$HOME/Documents/TT/ZSH_Funcs"

# If the above directory exists, then begin sourcing.
if [ -d "$FLIB" ]
then
	for FUNC in\ 
	\
		# Add your shell files here which are to be sequentially sourced. To see which ones
		# I use and have written myself, check the directory 'ZSH_Funcs' in this repository.
	{
	        source "$FLIB/$FUNC"
	}
fi

# Clean up some variables to avoid them unnecessarily lingering.
unset FLIB FUNC
