#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.profile
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Thu 31 Dec 01:00:09 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------

{
	# The RHEL recommended umask for much more safety when creating new files
	# and directories. This is the equivalent of octal 700 and 600 for
	# directories and files, respectively; drwx------ and -rw-------.
	umask 0077

	# I need this for when I use my configurations remotely, via SSH.
	[ -n "$SSH_TTY" -a -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

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
} 1> /dev/null

# Need this for when I'm using the proprietary nVidia driver, because it
# insists on automatically setting it to something far too small.
xrandr --dpi 96 &> /dev/null

if [ -f "$HOME"/.bashrc ] && [[ `tty` == '/dev/tty*' ]]; then
	. "$HOME"/.bashrc
fi
