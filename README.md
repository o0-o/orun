# _ORUN_
## A (mostly) \*nix-agnostic, extensible, heuristic script wrapper

`orun` is a wrapper for scripts in `/lib/orun`. The command `orun do this please` will attempt to run `/lib/orun/orun_do_this_please.EXT` where `EXT` is either `sh`, `pl`, `py` or `rb`.

`orun` will use either ZSH or BASH depending on what is available. It prefers ZSH but will fallback to BASH if it's at least version 4. This allows `orun` to operate on systems without ZSH while preferring ZSH over the antiquated version of BASH on macOS. `orun` also requires version 3 of Python. Currently, it does not check for versions of Perl or Ruby, but it may in the future.

While `orun` will look for library scripts with the `orun_` prefix, those prefixed scripts typically call their own subscripts, each responsible for an atomic operation. In most cases, the prefixed scripts are platform-agnostic while each subscript performs platform-specific operations. Prefixed scripts rely on trial-and-error logic as long as command failure is non-destructive (`command not found` usually). Subscripts are very short and completely free of boilerplate. Subscripts may be AWK or TCL/Expect in addition to Perl, Ruby or Python.

`orun_sw_check-update.sh`
```
# Check for software updates

source "${__LIB_PATH}/check-update_rhel.sh" ||
source "${__LIB_PATH}/check-update_deb.sh"  ||
source "${__LIB_PATH}/check-update_bsd.sh"  ||
source "${__LIB_PATH}/check-update_mac.sh"  ||

return 1

return 0

```

`sw_check-update_rhel.sh`

```
# Check for software updates on Red Hat, CentOS or Fedora Linux

# Fedora and recent versions of CentOS/RHEL
{ sudo dnf check-update ||
  # exits 100 when updates are available
  [ "$?" -eq '100' ]
} ||

# Earlier versions of CentOS/RHEL
{ sudo yum check-update ||
  # exits 100 when updates are available
  [ "$?" -eq '100' ]
} ||

return 1

return 0

```

etc...

`orun` will accept arguments normally or via pipe. When combined, piped arguments are appended.

```
$ echo 'HELLO YOURSELF' | orun data str lcase 'HELLO WORLD'
hello world
hello yourself
```

---

Currently, `orun` is written for my personal use. It takes some liberties that you might not expect. Namely:

1. `orun` will automatically install Python 3 with no prompt.
1. On macOS, `orun` will automatically install Homebrew with no prompt.
