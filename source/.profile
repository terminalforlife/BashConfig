#----------------------------------------------------------------------------------
# Project Name      - BashConfig/source/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Thu 23 Jan 14:52:53 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Things I would usually put in this file are processed by i3-wm when it starts.
#--------------------------------------------------------------------------THE VOID

# The RHEL recommended umask for much more safety when creating new files and
# directories. This is the equivalent of octal 700 and 600 for directories and
# files, respectively; drwx------ and -rw-------.
umask 0077

# If using Arch, enable bash completion. Comment out if you get this elsewhere.
if [ -x /usr/bin/pacman -a /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
fi

# Set up the SSH agent for key management.
if eval `ssh-agent -s` 1> /dev/null; then
	ssh-add "$HOME/.ssh/rsa_ss"
	trap 'kill $SSH_AGENT_PID' EXIT
fi
