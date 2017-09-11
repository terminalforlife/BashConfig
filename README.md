# bashconfig
Bash configuration files I created to use and share.

QUICK NOTES
-----------

The .bashrc file is something I've enjoyed working on here and there since I got into Linux and shell programming. It's gone through so very many stages, improving as my shell and Linux knowledge improved.

The file is not entirely meant to be used as-is, so be sure to make the necessary changes so that it is functional for you. There
will likely be only a few changes the typical user would want to make, like removing plugins you don't need or changing paths.

The main thing you'll want to change is the location of your function library (or files you're okay being sourced by .bashrc), and to enter into the for loop the files you wish to be sourced, many of which I've written I will provide here, as I find some of them very useful and can see others finding the same.

If you have any issues or recommendations, for .bashrc or for anything else you see here, please let me know.

HOW TO USE
----------

Using these files is very simple:

  1. Place .bashrc into $HOME/
  2. Create directory "ShellPlugins" in $HOME/
  3. Place contents of ShellPlugins from this respository into the above.
  4. Place .profile (entirely optional) into $HOME/
  
Remember, these are my files and how I've customized them; if you have your own customizations, be sure you back them up beforehand! Otherwise simply copying over your existing files with mine will blast yours away. While they work for me just fine, they may cause unknown issues for you. Back up your files beforehand, perhaps by using this command, but not with sh:

cp $HOME/.bashrc{,bak}
cp $HOME/.profile{,bak}

If you already have the directory ShellPlugins, make changes to and run this sed command, where X is the name of the directory you'd like to instead use, and FILE is the location of the .bashrc file you got from me.

sed -i 's/ShellPlugins/X/' FILE

ASSUMPTIONS
-----------

Some of the code in .bashrc, .profile, and anything I share in ShellPlugins is meant to be looked at by you and customized to fit your needs. I'm just supplying my personal configuration and some plugins I've written and will write, while also keeping in mind that others might want to use it. So, with that, I'm expecting at least some prior shell knowledge.

The .bashrc file is written for bash, so most of the code is using bash syntax, which wouldn't work on shells like sh and dash. I'm assuming therefore, that you're using bash - obviously. I've got this running without issue on: Bash v4.3

Aside from that, I've tried to keep assumptions down low. For example, the aliases are only active if they apply to you; if you have the file, or the directory, or the program, etc. I'm sure you'd want to go through and delete a bunch of things you don't nor will ever want. I don't usually litter my scripts with comments -- too many bugs me, honestly -- but I will go into some detail here in this README.md file, so feel free to continue reading.

CAUTION
-------

Some things are still a work in progress, perhaps even abandoned or forgotten, such as the odd ShellPlugins.

WALKTHROUGH
-----------

The following information will be referencing specific lines, or ? for any or no specific line/s.

7-10:
If not already done elsewhere, add $HOME/bin to your environment variable PATH, but only if the directory exists.

12:
Set a much, much more secure umask than you'll typically find in distributions. 0077 is recommended by the RHEL crowd.

14:
The usual check for an interactive shell; if not, then don't process the rest of the file.

18-21:
Set various shell options with the shopt bash builtin. Enables various useful bash features. See man bash(1).

23-24:
Similar to the above, but just a different category of options which are set. Also see man bash(1).

28-43:
If you're not on a TTY (so basically, in a PTS) set prompt PS1, PS2, PS3, and PS4 to something minimalistic, using a fancy arrow for PS1, and set a sound to play whenever the prompt loads. If, however, you're on a TTY, set the prompts to something even more basic and do away with the sound, just in-case it causes issues on a slower machine.

45:
Set the bash history variables. "ignoreboth" ignores entries starting with a space (Ex: " ls") and also duplicated entries, such as entering ls, then ls again. I've set a time format so you get the date and time of the command's execution. I don't use a bash history file, for security reasons, but I use the history stored temporarily, until the terminal is closed. 1000 lines are saved temporarily.

49:
This is where you set the location of your ShellPlugins directory, in-case you wanted it somewhere else, or in a different name.

51-65:
Source each of the files (scripts) in the above directory, but only if they exist. I've placed some of my own, including personal ones I likely won't be sharing, just to give you an idea of how it looks with stuff there. You can of course organise it differently.

69:
I use this environment variable for VirtualBox, so it knows where my virtual machines are stored.

70:
This removes the /snap/bin location from the PATH environment variable, if it's there and placed at the end of PATH, as I simply don't care for it. If you wish to keep it, please remove this line.

71:
These are my LS_COLORS; nice and simple, but I love them and have been using them for quite some time. They work really well with dark-colored terminals, but unfortunately suck on lighter terminals, so you may wish to change them.

72:
This just ensures my terminal shows colors correctly.

73:
Enables a more secure less and pager, by disabling certain features which are a potential vulnerability. See man less(1).

75-84:
If /usr/bin/sudo is found, set the SUDO_EDITOR environment variable for the sudo -e command. If /usr/bin/vim is found, that will be used, otherwise /usr/bin/nano will be used. If those two are aren't found, then you'll have to set it yourself.

88-99:
Just enables bash completion, if available.

103-115:
A tiny plugin I wrote a while back which handily logs whenever a terminal is opened, including some handy bits of information. The log will be saved in $HOME/.termwatch.log but you can change that by changing the TERMWATCH_LOGFILE variable.

119-133:
Sets up aliases for grabbing YouTube videos using /usr/bin/youtube-dl (or /usr/local/bin/youtube-dl) either for audio, or audio and video, via playlists or a single file.

135-143:
If /usr/bin/apt-get and /usr/bin/sudo is found on your system, then enable a bunch of handy aliases for that command, such as quf to remove and purge a package(s); short for "/usr/bin/sudo /usr/bin/apt-get remove --purge".

145-151:
If /usr/bin/apt-cache is found, create aliases for that, similar to above.

153-156:
If /bin/dd, /bin/pidof, and /usr/bin/sudo are found, then create an alias which displays progress with dd during operation. It's just a hack, really, and not necessary in later versions of coreutils, but in Ubuntu 16.04.3, I believe I need it.

158-167:
If /sbin/modinfo, /sbin/lsmod, and /usr/bin/cut are found, create a handy alias which shows a list of active kernel modules with their short descriptions, in a way similar to the "apt-cache search" format. If no description is found, I believe just the name with a hyphen will be printed.

169-172:
If /bin/dmesg is found, create a simple alias which shows what I find preferable with that command. See man dmesg(1).

174-177:
If /usr/bin/vboxsdl is found (VirtualBox; GUI not necessary), create an alias which autosets your hostkey to what for me (on a UK keyboard layout) is the right Ctrl key.

To be continue...
