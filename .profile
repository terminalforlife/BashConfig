# Written by terminalforlife (terminalforlife@yahoo.com)

if type -P /usr/bin/{cut,pactl} /bin/grep &> /dev/null
then
	export PA_DEF_SOURCE=`/usr/bin/pactl info short\
		| /bin/grep "Default Source:"\
		| /usr/bin/cut -d " " -f 3-`
	export PA_DEF_SINK=`/usr/bin/pactl info short\
		| /bin/grep "Default Sink:"\
		| /usr/bin/cut -d " " -f 3-`
fi

if [ "$BASH" == "/bin/bash" ] && [ -f "$HOME/.bashrc" ]
then
	source "$HOME/.bashrc"
fi
