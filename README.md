# bashconfig
Bash configuration files I created to use and share.

QUICK NOTES
-----------

The .bashrc file is something I've enjoyed working on here and there since I got into Linux and shell programming. It's gone through so very many stages, improving as my shell and Linux knowledge improved.

The file is not entirely meant to be used as-is, so be sure to make the necessary changes so that it is functional for you. There
will likely be only a few changes the typical user would want to make, like removing plugins you don't need or changing paths.

The main thing you'll want to change is the location of your function library (or files you're okay being sourced by .bashrc), and to enter into the for loop the files you wish to be sourced, many of which I've written I will provide here, as I find some of them very useful and can see others finding the same.

If you have any issues or recommendations, for .bashrc or for anything else you see here, please let me know.

INSTALLATION
------------

Paste these commands out into a terminal, using bash, line-by-line. But first off, let's back up your existing files, in-case of any conflicts:

    for I in .{bash{rc,_aliases},profile}; { cp -i "$I"{,_tfl.bak}; }
    [ -d "$HOME/ShellPlugins" ] && mv -i "$HOME/ShellPlugins"{,_tfl.bak}

ASSUMPTIONS
-----------

Some of the code in .bashrc, .profile, and anything I share in ShellPlugins is meant to be looked at by you and customized to fit your needs. I'm just supplying my personal configuration and some plugins I've written and will write, while also keeping in mind that others might want to use it. So, with that, I'm expecting at least some prior shell knowledge.

The .bashrc file is written for bash, so most of the code is using bash syntax, which wouldn't work on shells like sh and dash. I'm assuming therefore, that you're using bash - obviously. I've got this running without issue on: Bash v4.3

Aside from that, I've tried to keep assumptions down low. For example, the aliases are only active if they apply to you; if you have the file, or the directory, or the program, etc. I'm sure you'd want to go through and delete a bunch of things you don't nor will ever want.

CAUTION
-------

Remember, these are my files and how I've customized them; if you have your own customizations, be sure you back them up beforehand! Otherwise simply copying over your existing files with mine will blast yours away. While they work for me just fine, they may cause unknown issues for you. Back up your files beforehand, perhaps by using this command, but not with sh:

cp $HOME/.bashrc{,bak}

cp $HOME/.profile{,bak}

Some things are still a work in progress, perhaps even abandoned or forgotten, such as the odd ShellPlugins.
