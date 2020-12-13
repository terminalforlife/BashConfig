#!/bin/sh

#------------------------------------------------------------------------------
# Project Name      - BashConfig/devutils/links.sh
# Started On        - Sun 22 Oct 00:15:02 BST 2017
# Last Change       - Sun 13 Dec 05:11:41 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# Just a simple, quick script to update the hard links when changing branches.
#------------------------------------------------------------------------------

{
	if cd "$HOME/GitHub/terminalforlife/Personal/BashConfig/source"; then
		for CurFile in\
		\
			.inputrc .yashrc .profile .bash_logout .git-prompt\
			.bash_aliases .bash_functions .bashrc
		do
			rm -v "$HOME/$CurFile"
			ln -v "$CurFile" "$HOME/$CurFile"
		done
	fi
} 2> /dev/null
