#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - bashconfig/update_links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Mon 18 Nov 16:10:36 GMT 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Just a simple, quick script to update the hard links when changing branches.
#------------------------------------------------------------------------------MAIN

FAIL(){
	printf "[L%0.4d] ERROR: %s\n" "$2" "$3" 1>&2
	[ $1 -eq 1 ] && exit 1
}

declare -i DEPCOUNT=0
for DEP in rm ln; {
	if ! type -fP "$DEP" > /dev/null 2>&1; then
		FAIL 0 "$LINENO" "Dependency '$DEP' not met."
		DEPCOUNT+=1
	fi
}

[ $DEPCOUNT -eq 0 ] || exit 1

[ "${PWD//*\/}" == "BashConfig" ] || FAIL 1 "Not in the repository's root directory."

for FILE in .bashrc .bash_aliases .bash_functions .bash_logout .profile; {
	rm -v $HOME/$FILE 2>&-
	ln -v $FILE $HOME/$FILE 2>&-
}

for FILE in .shplugs/*; {
	rm -v $HOME/$FILE 2>&-
	ln -v $FILE $HOME/$FILE 2>&-
}

rm -v $HOME/.inputrc 2>&-
ln -v .inputrc $HOME/.inputrc 2>&-
