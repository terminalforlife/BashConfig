#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - bashconfig/update_links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Thu  8 Mar 05:28:12 GMT 2018
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Just a simple, quick script to update the hard links when changing branches.
#------------------------------------------------------------------------------MAIN

XERR(){ printf "[L%0.4d] ERROR: %s\n" "$1" "$2" 1>&2; exit 1; }
ERR(){ printf "[L%0.4d] ERROR: %s\n" "$1" "$2" 1>&2; }

declare -i DEPCOUNT=0
for DEP in /bin/{ln,rm}; {
	[ -x "$DEP" ] || {
		ERR "$LINENO" "Dependency '$DEP' not met."
		DEPCOUNT+=1
	}
}

[ $DEPCOUNT -eq 0 ] || exit 1

[ "${PWD//*\/}" == "bashconfig" ] || XERR "Not in the repository's root directory."

for FILE in .bashrc .bash_aliases .bash_functions .profile; {
	/bin/rm -v $HOME/$FILE 2> /dev/null
	/bin/ln -v $FILE $HOME/$FILE 2> /dev/null
}

for FILE in ShellPlugins/*; {
	/bin/rm -v $HOME/$FILE 2> /dev/null
	/bin/ln -v $FILE $HOME/$FILE 2> /dev/null
}
