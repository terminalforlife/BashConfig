**MASTER** - _Hopefully stable branch._\
**DEV** - _Development Branch (latest changes)_

# Introduction to BashConfig

Thank you for checking out my exhaustive [Bourne Again Shell](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) configuration files. Here, you'll not find some generic, copy-paste dotfiles, but in-fact thoughtful, purposeful code I've lovingly written and updated entirely myself, over several years.

While this configuration isn't directly, specifically intended for use by anybody without any prior configuration from the user, it still can be migrated over to your needs, or just be used as an educational aid.

Below are some of the features on offer, at the time of writing this.

  * Plenty to explore, with ~2,130 lines; ~1,900 of which is _actual_ code to paw through.
  * Useful tool called `lad` to list and describe available functions and/or aliases.
  * Clean, concise `.inputrc` file with handy tweaks to how Bash operates interactively.
  * A `.bash_functions` file with ~33 functions, big and small, for a better workflow.
  * A `.bash_aliases` file with well over 50 aliases, covering a wide range of uses.
  * An extensive but in-excessive `.bashrc` file with an elegant git-supported prompt.
  * The included prompt's brother, `gitsa`, offers an overview of your branches.
  * All syntax from these configuration files is in line with Bash's POSIX mode.
  * Various easy-to-set variables at the start of `.bashrc` for inexperienced users.
  * Functions and aliases are situational, in that they're only active when applicable.
  * Several useful shell options (`shopt`) and settings (`set`) are enabled.
  * Subtle, consistent colors -- absolutely no rainbows can be found over here!
  * Various lesser-known `export` usages, such as for the `ps` and `time` tools.
  * In `.bashrc`, resides a small feature which logs when the terminal is open.
  * A fresh lick of paint is applied to man pages, making for an easier read.
  * The massively-useful ability to use `sudo` even on aliases and functions.

# Do You Have Any Questions?

I'm going to pre-emptively attempt to answer some questions:

  **Q: Can I disable the POSIX mode used in Bash?**
    A: Yes. You need only set `POSIX_MODE='true'` to `'false'` instead.

  **Q: I've written my own plugin; can I add it?**
    A: Yes. Add its filename to the `PLUGINS` array assigned early in `.bashrc`.

  **Q: My version of Bash is older than 4.0; can I still use this?**
    A: Probably not, but an experienced user could maybe get it working.

  **Q: Can I add my own user option (variable) to the starting area of `.bashrc`?**
    A: Absolutely, and if it's a boolean, you might want to use the `for OPT in` bit.

  **Q: I don't understand the symbols used in the git prompt. Help!**
    A: You'll soon remember them, but check out the `GI` array in `.bashrc` first.

  **Q: The git prompt isn't working for me. What can I do?**
    A: Post a bug report on GitHub or send me an E-Mail: terminalforlife@yahoo.com

  **Q: What is the `000` in the prompt? It keeps changing to weird numbers!**
    A: Don't worry, that's just the [exit status](https://bash.cyberciti.biz/guide/The_exit_status_of_a_command) of the previously-executed command.

  **Q: Will this configuration work at all on other shells, like ZSH?**
    A: Nope, but some of it would, with some tweaking. Bash-only syntax will fail.

  **Q: How can I learn how you program in shell? You use syntax I've never seen.**
    A: Aside from research and practice, you can visit my [YouTube](https://www.youtube.com/channel/UCfp-lNJy4QkIGnaEE6NtDSg) channel, 'Learn Linux'.

  **Q: Will this configuration work on Linux, BSD, Mac, and other platforms?**
    A: I've focused on Linux here, so probably not, but this may change in time.

# Installation Instructions

You've made it this far, so you probably want to try it out. Before you do that though, you should **back up** your files _beforehand_, to avoid losing important configurations.

The method I'm going to show you, because I'm being lazy, is using an extensive utility I wrote for such a purpose as this. Cito is a POSIX-compliant Bourne installer for local or files stored on GitHub.

* If you're on a Debian- or Ubuntu-based distribution of Linux, your best bet is:

  1. Open up a terminal, and keep it open until this is done.
  2. Run: `DebPkg='cito_2019-12-07_all.deb'; DomLink='https://raw.githubusercontent.com'`
  3. Run: `wget -qO "$DebPkg" "$DomLink/terminalforlife/DEB-Packages/master/$DebPkg"`
  4. Run: `sudo dpkg -i "$DebPkg" && rm "$DebPkg"`
  5. Now you need only run `cito --help` to see how to use it!

* If you're NOT on such a system, however, you can install via this one-liner:

  ```bash
  if TempFile=$(mktemp); then wget -qO "$TempFile" 'https://raw.githubusercontent.com/terminalforlife/Extra/master/source/cito' && sudo sh cito cito; fi
  ```

Then confirm it's working with:

  ```bash
  cito --help
  ```

You should get Cito's extensive usage information come up. If not, you might want to instead use Curl, so just directly replace `wget -qO` with `curl -so`, then re-execute the command.

Failing that, perhaps the temporary file creation didn't work, in which case just run:

  **WARNING: This will overwrite an existing file of the same name!**

  ```bash
  wget -qO ./cito 'https://raw.githubusercontent.com/terminalforlife/Extra/master/source/cito' && sudo sh cito cito
  ```

That should be all it'll take to get everything up and running.

#### So, now you have Cito -- now what?

From now on, Cito will make all of this so much easier, not to mention a bit safer and more robust. The following Cito commands, as of 2019-12-08, will do the leg work for you, so just run them one-by-one, for each file you want:

  ```bash
  sudo cito -r terminalforlife BashConfig master source/lad
  sudo cito -r terminalforlife BashConfig master source/.bashrc
  sudo cito -r terminalforlife BashConfig master source/.bash_functions
  sudo cito -r terminalforlife BashConfig master source/.bash_aliases
  sudo cito -r terminalforlife BashConfig master source/.inputrc
  sudo cito -r terminalforlife BashConfig master source/.profile
  sudo cito -r terminalforlife BashConfig master source/.shplugs/gitsa
  ```

If you're curious to know what happened, you can run `sudo cito -L all` to view all log lines, parsed from the raw `/var/log/cito-events.log` logfile. If you had any problems, please let me know so I can address them ASAP.

Thank you for your time and interest.

# How Can I Contribute?

You can share my GitHub and/or YouTube links to people, so more can make use of these programs and configurations I've spent hours upon hours working on and perfecting.

I'm also more than welcome to take pull requests on GitHub, and they will all be considered.
