#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.profile
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Sun 12 Dec 08:23:54 GMT 2021
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------

{
	# The RHEL recommended umask for much more safety when creating new files
	# and directories. This is the equivalent of octal 700 and 600 for
	# directories and files, respectively; drwx------ and -rw-------.
	umask 0077

	# Set up the SSH agent for key management.
	if eval `ssh-agent -s`; then
		# Only want to add keys on an SSH client, not the server.
		if [ "$HOSTNAME" == 'Z11' ]; then
			[ -z "$SSH_TTY" ] && ssh-add "$HOME"/.ssh/rsa_{ss,sam,vm}
		elif [ "$HOSTNAME" == 'Sam' ]; then
			[ -z "$SSH_TTY" ] && ssh-add "$HOME/.ssh/rsa_gitsam"
		fi

		trap 'kill $SSH_AGENT_PID' EXIT
	fi

	. "$HOME"/.bashrc

	PATH+=":$HOME/bin"
} &> /dev/null
