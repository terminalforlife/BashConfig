#!/bin/sh

#----------------------------------------------------------------------------------
# Project Name      - BashConfig/devutils/links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Tue 28 Jan 02:42:31 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Just a simple, quick script to update the hard links when changing branches.
#----------------------------------------------------------------------------------

set -e
. /usr/lib/tflbp-sh/ChkDep
set +e

ChkDep rm ln

cd "$HOME/GitHub/terminalforlife/Personal/BashConfig/source"

for CurFile in\
\
	.inputrc .yashrc .profile .bash_logout\
	.bash_aliases .bash_functions .bashrc
do
	rm -v "$HOME/$CurFile" 2> /dev/null
	ln -v "$CurFile" "$HOME/$CurFile" 2> /dev/null
done
