# bashconfig
Bash configuration files and more I created to use and share.

**MASTER** - _Hopefully stable branch._\
**DEV** - _Development Branch (latest changes)_

## INTRODUCTION

The .bashrc file is something I've enjoyed working on here and there since I got into Linux and shell programming. It's gone through so very many stages, improving as my shell and Linux knowledge improved.

The file is not entirely meant to be used as-is, so be sure to make the necessary changes so that it is functional for you. There will likely be only a few changes the typical user would want to make, like removing plugins you don't need or changing paths. User settings are at the top of the file. As for .bash\_aliases and .bash\_functions, you should be able to keep them as-is.

Some of the files to be sourced in the .bashrc for loop may need to be adjusted as I will use a different setup to you. There are a few plugins I've written here in this repository; some are useful to many, some are more obscure and weird. Some things I write are old, questionable things, some are newer. I try to update my code often though.

The lad file is a small shell program to list out (plus a few other features) functions and aliases available in the aforementioned files. This can be installed with insit (`insit lad`), as it has an entry of its own. You can also install the bashconfig entry in insit which will include lad, as well as necessary updates for the configuration files in the bashconfig repository, in order for it to work.

I recommend that you read the help output (`lad -h`) for lad, if you're planning on making and keeping any real code changes to the above configuration files, yet still plan to use lad.

If you have any issues or recommendations for anything you see here, please let me know.

## INSTALLATION

Before you install, you may want to back up any existing files beforehand!

Clone the repository (the green "Clone or download" button on this page) then drag the files into the right places. .shplugs directory (with its contents) goes in $HOME, .bash\_aliases, .bash\_functions, .bashrc, and (the sometimes used) .profile go in $HOME. You can also check out insit (via the installit repository) for to install and update bashconfig in a very easy, straight-forward way.

I should also point out that I removed /etc/profile, /etc/bash.bashrc, and various other system files related to bash, as they are either redundant (why source and test for bash\_completion every which where possible?!); I've yet to experience any negatives from this. I prefer my root account and any other local account I create be set to mostly standard bash defaults. If you wanted to do the same, be sure to back up your files beforehand!

## REQUIREMENTS

On a Debian/Ubuntu system, aside from the obvious (bash!) at least these packages are required for this to work:

* fonts-opensymbol
* fonts-symbola

This list will be changed as requirements are realised or added.

## LIMITATIONS

I sadly cannot guarantee that this repository will work for all setups; in-fact, I definitely can't! I've got too many projects and only so much time which I would rather spend on the actual code, (it would be great if people could help me test it) but here is what I use, as of 2019-04-11:

```
Distribution Base:        Ubuntu 16.04.6
Kernel Version:           4.15.0-47-generic
Desktop Environment:      i3-wm 4.11
Bash Version:             4.3.48(1)-release
```

As you might have guessed, I use Linux and have targeted Linux users with all of my shell stuff; that said, where possible, I want to compensate for those on systems like Mac and BSD. I have next-to-zero experience on Mac and BSD, so there's only so much I can do there. However, if you spot an incompatibility that has gone unchecked, please let me know, so we can get it addressed.

I endeavor to use absolute paths in all my work, so if you have compiled your own system with something like Gentoo or LFS, then you will probably run into issues; if this is a popular issue, I would consider at least offering a patch for which changes all the paths for ones you use; no guarantees there.

## CAUTION

If needed, be sure to back your own files up beforehand! Newer versions of insit already have a backup feature built in, but there's no harm in doing it yourself.
