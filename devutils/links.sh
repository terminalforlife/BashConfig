#!/bin/sh

#----------------------------------------------------------------------------------
# Project Name      - BashConfig/devutils/links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Sun  8 Dec 16:05:44 GMT 2019
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

cd .shplugs

for CurFile in *; do
	rm -v "$HOME/.shplugs/$CurFile" 2> /dev/null
	ln -v "$CurFile" "$HOME/$CurFile" 2> /dev/null
done
