#----------------------------------------------------------------------------------
# Project Name      - $HOME/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Fri 15 Sep 16:03:58 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

if type -P /usr/bin/{cut,pactl} /bin/grep &> /dev/null
then
	export PA_DEF_SOURCE=`/usr/bin/pactl info short\
		| /bin/grep "Default Source:"\
		| /usr/bin/cut -d " " -f 3-`
	export PA_DEF_SINK=`/usr/bin/pactl info short\
		| /bin/grep "Default Sink:"\
		| /usr/bin/cut -d " " -f 3-`
fi

if [ -n "$BASH_VERSION" ]
then
	BRC="$HOME/.bashrc"

	if [ -f "$BRC" ] && [ -r "$BRC" ]
	then
		source "$BRC"
	fi

	unset BRC
fi
