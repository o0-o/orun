# Verbosity and logging defaults
: ${verbosity:=notice}
# If --log-level flag is used, enable syslog by default
[ ! -z "${log_level-}" ]  && : ${syslog:=true}
: ${syslog:=false}
: ${log_level:=$verbosity}

# Verbosity/log levels from most to least verbose
declare -a levels=( 'debug' 'info' 'notice' 'warning'
                    'err'   'crit' 'alert'  'emerg'   )             &&

# Additional verbosity options
case "${verbosity}" in
  'silent'  )         declare     _stdout='/dev/null' ;&
  'quiet'   )         declare     _stderr='/dev/null' ;;
  'trace'   ) set -x; declare   verbosity='debug'
                      declare       trace='true'      ;;
esac                                                                &&
: ${_stdout:=1}                                                     &&
: ${_stderr:=2}                                                     &&
exec {fd}>&"${_stdout}" && declare _stdout_alt="${fd}"  && unset fd &&
exec {fd}>&"${_stderr}" && declare _stderr_alt="${fd}"  && unset fd ||
{ printf 'Failed to set verbosity/log parameters\n' >&2; return 1; }

# Configure file descriptor and redirects for each active level
for level in "${levels[@]}"; do

  # Activate when configured verbosity reached
  [ "${verbosity}" = "${level}" ]                       &&
  declare print_to="${_stderr}"                         || :

  # Activate when configured log level is reached with syslog flag
  "${syslog}"                                           &&
  [ "${log_level}" = "${level}" ]                       &&
  declare logging='true'                                || :

  # Redirect file descriptor to syslog and stderr if verbosity permits
  { "${logging-false}"    &&
    exec {fd}> >( tee "${print_to-/dev/null}"   |
                    sed 's/^[[:space:]]*//'     |
                    logger  -p "user.${level}"  \
                            -t "${_name}"         )
  }                                                     ||

  # Redirect file descriptor to stderr
  { [ ! -z "${print_to-}" ] &&
    exec {fd}>&"${print_to}"
  }                                                     ||

  { [   -z "${print_to-}" ] && ! "${logging-false}"; }  ||

  # Catch failure
  { printf 'Failed to configure file descriptors for %s\n' "${level}" >&2
    return 1; }

  # Set $_level to the file descriptor or null if not used
  declare -r "_${level}"="${fd-/dev/null}"

  # Debug
  declare debug_parameter_format='%13s = %s\n'
  [ "${level}"      = 'debug' ]                         &&
  [ "${verbosity}"  = 'debug' ]                         &&
  source  "${_lib_path}/debug_header.sh"                || :
  printf  "${debug_parameter_format}"     \
          "${level}" "FD${fd-/dev/null}"  >&"${_debug}" || :

  unset fd

done                                                        ||
{ printf 'Failed to configure verbosity/log file descriptors\n' >&2;
  return 1; }

# Set defaults
: ${trace:=false}

return 0
