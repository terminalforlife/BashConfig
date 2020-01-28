**MASTER** - _Hopefully-Stable Branch._\
**DEV** - _Development Branch (Latest Changes)_\
**BULKY** - _The Old, Bulkier Iteration_

# Introduction to BashConfig

Thank you for checking out my somewhat-exhaustive [Bourne Again Shell](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) configuration files.

Here are some of the features I get out of this, as of 2020-01-28:

  * Lots of user-side tweaks available, via `.inputrc`.
  * Lad, a tool to list and describe functions and/or aliases, is included.
  * Both `.bash_functions` and `.bash_aliases` included, with plenty inside.
  * Customized `.bashrc` with a custom git prompt -- see also: GitSAP.
  * Within these files is code written with Bash's POSIX mode in mind.
  * Functions and aliases are situational, applying only when valid.
  * Several useful shell options (`shopt`) and settings (`set`) are enabled.
  * Subtle, consistent colors -- absolutely no rainbows can be found over here!
  * Various lesser-known `export` usages, such as for the `ps` and `time` tools.
  * A fresh lick of paint is applied to man pages, making for an easier read.
  * The massively-useful ability to use `sudo` even on aliases and functions.

# Do You Have Any Questions?

I'm going to pre-emptively attempt to answer some questions:

  **Q: My version of Bash is older than 4.0; can I still use this?**\
    A: Probably not, but an experienced user could maybe get it working.

  **Q: I'm seeing weird symbols in the prompt; I think it's broken!**\
    A: You're probably missing the Symbola and/or OpenSymbol fonts the prompt uses.

  **Q: I don't understand the symbols used in the git prompt. Help!**\
    A: You'll soon remember them, but check out the `GI` array in `.bashrc` first.

  **Q: The git prompt isn't working for me. What can I do?**\
    A: Post a bug report on GitHub or send me an E-Mail: terminalforlife@yahoo.com

  **Q: What is the `000` in the prompt? It keeps changing to weird numbers!**\
    A: Don't worry, that's just the [exit status](https://bash.cyberciti.biz/guide/The_exit_status_of_a_command) of the previously-executed command.

  **Q: Will this configuration work at all on other shells, like ZSH?**\
    A: Nope, but some of it would, with some tweaking. Bash-only syntax will fail.

  **Q: How can I learn how you program in shell? You use syntax I've never seen.**\
    A: Aside from research and practice, you can visit my [YouTube](https://www.youtube.com/channel/UCfp-lNJy4QkIGnaEE6NtDSg) channel, 'Learn Linux'.

  **Q: Will this configuration work on Linux, BSD, Mac, and other platforms?**\
    A: I've focused on Linux here, so probably not, but this may change in time.

# How Can I Contribute?

You can share my GitHub and/or YouTube links to people. I'm also more than welcome to take pull requests on GitHub, and they will _all_ be considered.

Thank you for your time and interest.
