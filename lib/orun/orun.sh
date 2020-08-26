# Main library
# Should be run in zsh or bash 4+

# Safety first
set -euo pipefail

# Debug
#set -x

# Trap
declare -a SIGS=('ERR' 'TERM' 'INT' 'QUIT' 'KILL' 'EXIT')
for SIG in "${SIGS[@]}"; do
  trap -- 'catch_all $? "${LINENO}" '"${SIG}" "${SIG}"
done

# Clean up temporary directory on error, exit, interrupt, etc
catch_all () {
  CODE="${1-'1'}"
  LINE="${2-'UNKNOWN'}"
  SIG="${3-'UNKNOWN SIGNAL'}"
  rm -rf -- "${__TMP_PATH-'/dev/null'}" 2>/dev/null || :
  [ ! "${SIG-}" = 'EXIT' ] &&
  printf '%s\n'                 \
    "${SIG-} at line ${LINE-}." \
    'Exiting...' >&2
  exit "${CODE-'1'}"
}

# Set supported extensions
declare -a  EXTS_VALID=('sh' 'py' 'pl' 'rb')  ||
{ printf '%s\n' 'Failed to set supported extensions.' >&2; return 1; }

# Make zsh like bash
declare SH="$(source "${__LIB_PATH}/sw_shell.sh")"  &&
[ "${SH}" = 'zsh' ]                                 &&
emulate -L bash                                     ||
[ "${SH}" = 'bash' ]                                ||
{ printf '%s\n' 'Failed to make zsh like bash.' >&2; return 1; }

# Check if Homebrew is installed on macOS and install it if not found
source "${__LIB_PATH}/sw_kernel_name.sh" | grep -iq "Darwin"  &&
! command -v brew >/dev/null                                  &&
{ printf '%s\n'               \
    'Homebrew not detected.'  \
    'Installing Homebrew in 5 seconds...' >&2   &&
  sleep 5                                       &&
  source "${__LIB_PATH}/sw_install_homebrew.sh" ||
  { printf '%s\n' 'Failed to install Homebrew.' >&2; return 1; }
}                                                             ||
: #not macOS, or is macOS with homebrew so continue

# Discover Python version 3 command
declare PYTHON="$(command -v 'python3' 2>/dev/null)"  ||
{ python --version |
    egrep -q "Python 3\.[0-9]+\.[0-9]+" &&
  declare PYTHON="$(command -v 'python' 2>/dev/null)"
}                                                     &&
readonly PYTHON                                       ||

{ # Python 3 not found so install it
  printf '%s\n'               \
    'Python 3 not detected.'  \
    'Installing Python 3 in 5 seconds...' >&2 &&
  sleep 5                                     &&
  source "${__LIB_PATH}/sw_install_python3.sh"      ||
  { printf '%s\n' 'Failed to install Python 3.' >&2; return 1; }
}                             ||

{ printf '%s\n' 'Python not available.' >&2; return 1; }

# Parse arguments
source "${__LIB_PATH}/parse-args.sh" || #sets COMMAND_LIB, OPTS and VALS
{ printf '%s\n' 'Failed to parse arguments.' >&2; return 1; }

# Look for libraries matching the subommand with supported extensions and
# execute the first match
for EXT in "${EXTS_VALID[@]}"; do
  [ -f "${__LIB_PATH}/${COMMAND_LIB}.${EXT}" ] &&
  { [ "${EXT}" = 'sh' ]                           && #source shell libs
    source "${__LIB_PATH}/${COMMAND_LIB}.${EXT}"  || #otherwise execute w/args
    "${__LIB_PATH}/${COMMAND_LIB}.${EXT}" "${OPTS[@]-}" "${VALS[@]-}"
  }
  return $?
done

{ printf '%s\n' 'Failed to exit before end of the main library.' >&2
  return 1; }
