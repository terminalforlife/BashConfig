**MASTER** - _Hopefully stable branch._\
**DEV** - _Development Branch (latest changes)_

To make use of these files, you'll have to install them manually, taking care to **back up** your own files _prior_ to overwriting them. The following instructions guide you through the backup process and actually installing ones in this repository.

Note that there's a very good chance I'll have added or removed files in this repository, but those changes were not reflected here, through the below commands. Provided you did everything right, and our planet didn't implode, all should be fine none-the-less.

In-case of any unforeseen problems, all commands shown below, which consist of more than one line of commands, are best run sequentially, _not_ all in one hit.

Begin by opening up your terminal, or start a new session:

```bash
Files=(.{inputrc,shplugs,bash{_{aliases,functions,logout},rc}})
\\printf -v Archive '%s/.B4-BC_%(%F_%X)T.tgz' "$HOME" -1
\\tar -czpf "$Archive" "${Files[@]}"
```

With the above, any of the files which would otherwise be overwritten, are backed up in a `tar` (archive, compressed with `gzip`). This archive can be found in `$HOME/` and will have the filename, for example, `.B4BC_2019-11-18_15\:12\:17.tgz`

Within the same terminal session (don't leave it, yet!) you'll now need to enter these commands to actually copy the files over, now that the old ones are backed up:

```bash
\\cp -t "$HOME" "${Files[@]}"
```

You _can_ leave the terminal session now.

You can use the following to _restore_ from the above made backup. Where `[ARCHIVE]` is the _path_ to the backup you want to restore.

```bash
\\tar -C "$HOME" -xzf [ARCHIVE]
```

If you have any issues with these instructions or the files from this repository, please let me know however you are able. Thank you.
