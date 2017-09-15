#----------------------------------------------------------------------------------
# Project Name      - $HOME/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Thu 14 Sep 20:09:33 BST 2017
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

if [ "$BASH" == "/bin/bash" ] && [ -f "$HOME/.bashrc" ]
then
	source "$HOME/.bashrc"
fi
