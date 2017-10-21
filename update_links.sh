#!/bin/sh

#----------------------------------------------------------------------------------
# Project Name      - update_links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Sun 22 Oct 00:19:12 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

# Just a simple, quick script to update the hard links when changing branches.

#------------------------------------------------------------------------------MAIN

ERR(){ printf "ERROR: %s\n" "$1" 1>&2; }

DEPCOUNT=0
for DEP in /bin/ln /bin/rm; {
	[ -x "$DEP" ] || {
		ERR "Dependency '$DEP' not met."
		DEPCOUNT=$(( DEPCOUNT + 1 ))
	}
}

[ $DEPCOUNT -eq 0 ] || exit 1

for FILE in .bashrc .bash_aliases .profile; {
	/bin/rm $HOME/$FILE && /bin/ln $FILE $HOME/$FILE
}
