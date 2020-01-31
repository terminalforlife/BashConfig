#!/usr/bin/env bash
#cito M:600 O:1000 G:1000 T:$HOME/.profile
#------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Fri 31 Jan 21:55:24 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------

# The RHEL recommended umask for much more safety when creating new files and
# directories. This is the equivalent of octal 700 and 600 for directories and
# files, respectively; drwx------ and -rw-------.
umask 0077

# I need this for when I use my configurations remotely, via SSH.
[ -n "$SSH_TTY" -a -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# If using Arch, enable bash completion. Comment out if you get this elsewhere.
if [ -x /usr/bin/pacman -a /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
fi

# Set up the SSH agent for key management.
if eval `ssh-agent -s` 1> /dev/null; then
	# Only want to add keys on an SSH client, not the server.
	if [ -z "$SSH_TTY" ]; then
		ssh-add "$HOME/.ssh/rsa_ss" "$HOME/.ssh/rsa_sam"
	fi

	trap 'kill $SSH_AGENT_PID' EXIT
fi
