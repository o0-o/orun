# _ORUN_
## A (mostly) \*nix-agnostic, extensible, didactic script wrapper

`orun` is a wrapper for scripts in `/lib/orun`. The command `orun do this please` will attempt to run `/lib/orun/orun_do_this_please.EXT` where `EXT` is either `sh`, `pl`, `py` or `rb`.

`orun` will use either ZSH or BASH depending on what is available. It prefers ZSH but will fallback to BASH if it's at least version 4. This allows `orun` to operate on systems without ZSH while preferring ZSH over the antiquated version of BASH on macOS. `orun` also requires version 3 of Python. Currently, it does not check for versions of Perl or Ruby, but it may in the future.

While `orun` will look for library scripts with the `orun_` prefix, those prefixed scripts typically call their own subscripts, each responsible for an atomic operation. In most cases, the prefixed scripts are platform-agnostic while each subscript performs platform-specific operations. Portability is achieved via trial-and-error logic as long as command failure is non-destructive (`command not found` usually). 

Subscripts are very short, include minimal boilerplate and may be written in AWK or TCL/Expect in addition to shell, Perl, Ruby or Python. Additionally, subscripts serve as a command reference, similar to a gist. While comments are succinct, they are written so that someone unfamiliar with the commands can make sense of them. Alternative versions of commands are also included (commented) to show how a command might be written on the fly.

## \*nix Agnostic

A somewhat bold claim. Realistically, `orun` targets compatibility with current versions of Debian, Ubuntu LTS, CentOS, Fedora, FreeBSD and macOS.

## Features

`orun` will accept arguments normally or via pipe. When combined, piped arguments are appended.

```
$ echo 'HELLO YOURSELF' | orun str lcase 'HELLO WORLD'
hello world
hello yourself
```

Variables can be set arbitrarily via `--var value` or `--var=value` anywhere in the command. No need to add additional command parsing logic for your script. The wrapper strips all flags from `$@` before calling the script, so `$1`, `$2`, etc only contain positional arguments. Please note that binary flags (`--force`, `--dry-run`, etc.) do need to be added to a case statement in `parse-args.sh`.

Any of:
```
$ orun --debug str lcase 'HELLO WORLD'
```

```
$ orun str --debug lcase 'HELLO WORLD'
```

```
$ orun --debug str lcase 'HELLO WORLD' --debug
```

Result in:
```
-------------------------------------------
|      ____     ___     __  __   _  __    |
|     / __ \   / _ \   / / / /  / |/ /    |
|    / /_/ /  / , _/  / /_/ /  /    /     |
|    \____/  /_/|_|   \____/  /_/|_/      |
|                                         |
-------------------------------------------
|  D        E        B        U        G  |
-------------------------------------------
        shell = zsh
         path = /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
  current dir = /Users/o0-o/.local/bin
          bin = /Users/o0-o/.local/bin
          tmp = /var/folders/qf/v5m1gmm90p321x3l2s__v7yh0000gn/T/orun/29762_38DA603A-DBD0-4F08-A703-35A1E64A5AB2
    verbosity = debug
       syslog = false
    log level = debug
           $1 = Hello world
       stdout = FD1
   stdout alt = FD14
       stderr = FD2
   stderr alt = FD15
    verbosity = debug
       syslog = false
    log level = debug
       stdout = FD1
   stdout alt = FD14
       stderr = FD2
   stderr alt = FD15
        debug = FD16
         info = FD17
       notice = FD18
      warning = FD19
          err = FD20
         crit = FD21
        alert = FD22
        emerg = FD23
+/Users/o0-o/.local/lib/orun/wrapper.sh:17> source /Users/o0-o/.local/lib/orun/str_lcase.sh
+/Users/o0-o/.local/lib/orun/str_lcase.sh:4> printf '%s\n' 'Hello world'
+/Users/o0-o/.local/lib/orun/str_lcase.sh:6> tr '[[:upper:]]' '[[:lower:]]'
hello world
+/Users/o0-o/.local/lib/orun/str_lcase.sh:13> return 0
+/Users/o0-o/.local/lib/orun/wrapper.sh:18> declare wrapper_return=0
+/Users/o0-o/.local/lib/orun/wrapper.sh:20> false
+/Users/o0-o/.local/lib/orun/wrapper.sh:20> set +x
```

`stderr` verbosity and syslog are fully supported using additional file descriptors which are assigned dynamically and can be used anywhere in wrapped scripts. `--verbosity=`, `--silent` (no output), `--quiet` (no stderr), `--info`, `--debug`, `--trace`, `--syslog`, `--log-level=` are currently supported. By default, syslog is disabled and stderr verbosity is set to notice. `--debug` will show a trace of the subcommand in addition to all uncaught stderr. `--trace` runs `set -x` as soon as the flag is processed.

In the example below, the info and warning messages will respect the verbosity and log-level values while any stderr from `something-command` will appear in debug.
```
something-command &&
echo 'something succeeded' >&"${_info}" ||
echo 'something failed' >&"${_warning}"
```

---

Currently, `orun` is written for my personal use. It takes some liberties that you might not expect. Namely:

1. `orun` will automatically install Python 3 with no prompt.
1. On macOS, `orun` will automatically install Homebrew with no prompt.
