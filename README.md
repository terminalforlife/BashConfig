**MASTER** - _Hopefully-Stable Branch._\
**DEV** - _Development Branch (Latest Changes)_\
**BULKY** - _The Old, Bulkier Iteration_

# Introduction to BashConfig

Thank you for checking out my somewhat-exhaustive [Bourne Again Shell](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) configuration files.

Here are some of the features I get out of this, as of 2020-01-28:

  * Lots of user-side tweaks available, via `.inputrc`.
  * A `.bash_functions` file included, with many useful functions.
  * Customized `.bashrc` with a written-from-scratch git(1) prompt.
  * All code in this repository aims to keep to BASH's POSIX mode.
  * Many functions are situational, applying only when valid.
  * Many useful shell options (`shopt`) and settings (`set`) are enabled.
  * Subtle, consistent colors -- no rainbows will be found over here!
  * Various lesser-known `export` usages, like for the `ps` and `time` tools.
  * A fresh lick of paint is applied to man pages, making for an easier read.

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

  **Q: I keep seeing red numbers in the prompt -- why?**\
    A: That's just the [exit status](https://bash.cyberciti.biz/guide/The_exit_status_of_a_command) of the previously-executed command.

  **Q: Will this configuration work at all on other shells, like ZSH?**\
    A: Some of it would, with some tweaking. BASH-only syntax will likely fail.

  **Q: Can I learn more about what you do in Linux?**\
    A: Absolutely! You can visit my [YouTube](https://www.youtube.com/channel/UCfp-lNJy4QkIGnaEE6NtDSg) channel, 'Terminalforlife (LL)'.

  **Q: Will this configuration work on non-Linux operating systems?**\
    A: I've only focused on Linux here, so probably not.

# How Can I Contribute?

You can share my GitHub and/or YouTube links to people. I'm also more than welcome to take pull requests on GitHub, and they will _all_ be considered.

Thank you for your time and interest.
