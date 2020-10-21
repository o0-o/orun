# Check if Homebrew is installed on macOS and install it if not found
source "${_lib_path}/sw_kernel_name.sh" | grep -iq "Darwin" &&
! command -v brew &>/dev/null                               &&
{ printf '%s\n'                           \
    'Homebrew not detected'               \
    'Installing Homebrew in 5 seconds...' >&2   &&
  sleep 5                                       &&
  source "${_lib_path}/sw_install_homebrew.sh"  ||
  { printf 'Failed to install Homebrew\n' >&2; return 1; }
}                                                           ||
true #not macOS, or is macOS with homebrew so continue

# Discover Python version 3 command
{ declare _python="$(command -v 'python3' 2>/dev/null)" ||
  { python --version 2>/dev/null          |
      egrep -q "Python 3\.[0-9]+\.[0-9]+" &&
    declare _python="$(command -v 'python' 2>/dev/null)"
  }                                                     ||

  { # Python 3 not found so install it
    printf '%s\n'                           \
      'Python 3 not detected'               \
      'Installing Python 3 in 5 seconds...' >&2                 &&
    sleep 5                                                     &&
    source "${_lib_path}/sw_install_python3.sh"                 &&
    declare _python="$(command -v 'python3' 2>/dev/null)"       ||
    { printf 'Failed to install Python 3\n' >&2; return 1; }
  }
} ||
{ printf 'Python 3 not available\n' >&2; return 1; }

# Load exit codes
source "${_lib_path}/exit-codes.sh" ||
{ printf 'Failed to load exit codes\n' >&2; return 1; }

# Parse arguments
source "${_lib_path}/parse-args.sh" ||
{ printf 'Failed to parse arguments\n' >&2; return 1; }

# Start stderr/log control
source "${_lib_path}/verbosity-and-logger.sh" ||
{ printf 'Failed to configure verbosity and logging\n' >&2; return 1; }

# Set supported extensions and execute first available
declare -a  exts_valid=('sh' 'awk' 'tcl' 'pl' 'py' 'rb')        &&
# Use the command wrapper to run $command_lib
# Redirect stdout based on verbosity and catch all stderr in debug
printf  '%s' "${command_lib}" |
  "${_script_wrapper[@]}"     1>&"${_stdout}" \
                              2>&"${_debug}"  ||

return "${?}"

return 0
