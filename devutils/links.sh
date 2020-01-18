#!/bin/sh

#----------------------------------------------------------------------------------
# Project Name      - BashConfig/devutils/links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Thu  9 Jan 18:44:46 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Just a simple, quick script to update the hard links when changing branches.
#----------------------------------------------------------------------------------

. /usr/lib/tflbp-sh/ChkDep

ChkDep rm ln

cd "$HOME/GitHub/terminalforlife/Personal/BashConfig/source"

for CurFile in .inputrc .yashrc .bashrc .bash_logout .bash_aliases .bash_functions; do
	rm -v "$HOME/$CurFile" 2> /dev/null
	ln -v "$CurFile" "$HOME/$CurFile" 2> /dev/null
done
