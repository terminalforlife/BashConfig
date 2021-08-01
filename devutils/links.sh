#!/bin/sh

#------------------------------------------------------------------------------
# Project Name      - BashConfig/devutils/links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Sun  1 Aug 20:56:40 BST 2021
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# Just a simple, quick script to update the hard links when changing branches.
#------------------------------------------------------------------------------

exec 2> /dev/null

if cd "$HOME/GitHub/terminalforlife/Personal/BashConfig/source"; then
	for CurFile in\
	\
		.inputrc .yashrc .profile .bash_logout\
		.bash_aliases .bash_functions .bashrc
	do
		ln -vf "$CurFile" "$HOME/$CurFile"
	done
fi
