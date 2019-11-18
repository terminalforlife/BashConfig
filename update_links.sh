#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - bashconfig/update_links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Thu  9 May 13:43:28 BST 2019
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

[ "${PWD//*\/}" == "BashConfig" ] || XERR "Not in the repository's root directory."

for FILE in .bashrc .bash_aliases .bash_functions .bash_logout .profile; {
	/bin/rm -v $HOME/$FILE 2>&-
	/bin/ln -v $FILE $HOME/$FILE 2>&-
}

for FILE in .shplugs/*; {
	/bin/rm -v $HOME/$FILE 2>&-
	/bin/ln -v $FILE $HOME/$FILE 2>&-
}

/bin/rm -v $HOME/.inputrc 2>&-
/bin/ln -v .inputrc $HOME/.inputrc 2>&-
