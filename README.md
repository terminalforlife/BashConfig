# bashconfig
Bash configuration files I created to use and share.

**MASTER** - _Hopefully stable branch._\
**DEV** - _Development Branch (latest changes)_

## INTRODUCTION

The .bashrc file is something I've enjoyed working on here and there since I got into Linux and shell programming. It's gone through so very many stages, improving as my shell and Linux knowledge improved.

The file is not entirely meant to be used as-is, so be sure to make the necessary changes so that it is functional for you. There will likely be only a few changes the typical user would want to make, like removing plugins you don't need or changing paths.

Some of the files you wish to be sourced in the .bashrc for loop will need to be adjusted as I will use a different setup to you. There are a few plugins I've written here in this repository; some are useful to many, some are more obscure and weird. Some things I write are old, questionable things, some are newer. I try to update my code often though.

If you have any issues or recommendations, for .bashrc or for anything else you see here, please let me know.

## INSTALLATION

Before you install, you may want to back up any existing files beforehand!

Clone the repository (the green "Clone or download" button on this page) then drag the files into the right places. .shplugs directory (with its contents) goes in $HOME, .bash_aliases, .bash_functions, .bashrc, and (the sometimes used) .profile go in $HOME. You can also check out insit (via the installit repository) for to install and update bashconfig in a very easy, straight-forward way.

I should also point out that I removed /etc/profile, /etc/bash.bashrc, and various other system files related to bash, as they are either redundant (why source and test for bash_completion every which where possible?!); I've yet to experience any negatives from this. I prefer my root account and any other local account I create be set to mostly standard bash defaults. If you wanted to do the same, be sure to back up your files beforehand!

## REQUIREMENTS

On a Debian/Ubuntu system, at least these packages are required for this to work:

* bash
* fonts-opensymbol

This list will be changed as requirements are realised or added.

## LIMITATIONS

I sadly cannot guarantee that this repository will work for all setups; in-fact, I definitely can't! I've got too many projects and only so much time which I would rather spend on the actual code, (it would be great if people could help me test it) but here is what I use:

```
Distribution Base:        Ubuntu 16.04.3
Kernel Version:           4.10.0-30-generic
Desktop Environment:      i3-wm 4.11-1
Bash Version:             4.3-14ubuntu1.2
```

However, now that Ubuntu 17.10 is out, I'll soon be upgrading, which means cleaning up and fully supporting Ubuntu 17.10! I've already began making changes.

As you might have guessed, I use Linux and have targeted Linux users with all of my shell stuff; that said, where possible, I try to compensate somewhat for those on systems like Mac and BSD. I have next-to-zero experience on Mac, and limited experience on BSD systems (briefly explored FreeBSD), so there's only so much compensating I can do there. However, if you spot an incompatibility that has gone unchecked, please let me know!

I endeavor to use absolute paths in all my work, so if you have compiled your own system with something like Gentoo or LFS, then you will probably run into issues; if this is a popular issue, I would consider at least offering a patch for which changes all the paths for ones you use.

## ASSUMPTIONS

Some of the code here is meant to be looked at by you and customized to fit your needs. Some of this is personal to my setup, but most is generic and should work for most people. I'm expecting at least some prior shell knowledge so you can make changes to fit your needs. At a later date, I might write up an interactive installer like installit (see my installit repository) for bashconfig.

The .bashrc file is written for bash, so most of the code is using bash syntax, which wouldn't work on shells like sh and dash. I'm assuming therefore, that you're using bash -- obviously!

Aside from that, I've tried to keep assumptions down to a minimum. For example, the aliases are only active if they apply to you; if you have the file, directory, or program, etc. I'm sure you'd want to go through and delete a bunch of things you don't nor will ever want.

## CAUTION

If needed, be sure to back your own files up beforehand! Otherwise you may blast away useful functionality which is applicable or required for your setup. While they work for me just fine, they may cause unknown issues for you. Back up your files beforehand, as shown above.

Some things are still a work in progress, perhaps even abandoned or forgotten, such as the odd .shplugs. I may wind up removing scripts I find useless, but I back things up a lot, so if you wind up missing them, let me know and I'll probably return them, perhaps in a separate directory within the repository.
