# Setup variables
declare -a     lib_illegal_chars=('.' '/')                    &&
declare              command_lib="${_name}"                   &&
declare     building_command_lib='true'                       &&
declare -a                params                              &&

# Build regex for valid extensions
declare exts_valid_re="("                                     &&
for ext in "${exts_valid[@]}"; do
  exts_valid_re+="${ext}|"
done                                                          &&
# Replace last | with )
exts_valid_re="${exts_valid_re:0:$((${#exts_valid_re}-1))})"  &&

# Build regex for valid library
declare lib_illegal_re="["                                    &&
for char in "${lib_illegal_chars[@]}"; do
  lib_illegal_re+="${char}"
done                                                          &&
lib_illegal_re="${lib_illegal_re}]"                           ||

{ printf 'Failed to set parsing variables' >&2; return 1; }

# Parse arguments into options, subcommands and values
while [ ! -z "${1}" ]; do
  case "${1}" in

    # Respect --
    '--'              ) shift && break                                    ;;

    # Split up grouped options
    '-'[[:alnum:]][[:alnum:]]*  )
      declare -a opt=( $( printf '%s' "${1#-}" | sed -e  's/./-& /g' ) )  &&
      shift                                                               &&
      opt+=("${@-}")                                                      &&
      set -- "${opt[@]}"                                                  ;;

    # Hardcoded flags
    '--silent'        ) declare verbosity='silent' && shift               ;;
    '-q'|'--quiet'    ) declare verbosity='quiet'  && shift               ;;
    '-v'|'--verbose'  ) declare verbosity='info'   && shift               ;;
    '--debug'         ) declare verbosity='debug'  && shift               ;;
    '--trace'         ) declare verbosity='trace'  && shift               ;;

    # Binary switches
    '--syslog'        ) declare    syslog='true'   && shift               ;;
    '--force'         ) declare     force='true'   && shift               ;;

    # Store options with arguments (preceded by hyphens)
    '--'[[:alnum:]]*  )
      declare -a opt=($(printf '%s' "${1#--}" | sed -e 's/=/ /'))         &&
      # Handle both --flag=value and --flag value
      { [ -z "${opt[1]-}" ] && shift && opt+=("${1}") || :; }
      declare "${opt[0]//-/_}"="${opt[1]-}"                               &&
      shift                                                               ;;

    [[:graph:]]*      )
      # Build subcommands as they correspond to libraries
      { "${building_command_lib}"                                 &&
        ! printf '%s' "${1}" | egrep -q "${lib_illegal_re}"       &&
        [ -f  "$( ls "${_lib_path}/${command_lib}_${1}"*  |
                    egrep -m '1' ".*\.${exts_valid_re}"     )" ]  &&
        command_lib+="_${1}"                                      &&
        shift
      } 2>/dev/null                                                       ||

      # Additional arguments are positional parameters for the
      # subcommand
      { declare building_command_lib='false' &&
        params+=("${1}") && shift            &&
      }                                                                   ;;

    *                 )
      printf 'Unrecognized arguments %s\n' "${1}" >&2; shift              ;;
  esac
done                          &&

# Add remaining arguments to parameters (this will occur if `--` is
# used)
params+=("${@-}")             ||
{ printf 'Failed to parse argument: %s\n' "${@-}" >&2; return 1; }

# If no subcommands were found, exit
[ "${command_lib}" = "${_name}" ] &&
{ printf 'Invalid subcommand\n' >&2; return 1; }

# Append piped data to parameters
[   -p '/dev/fd/0' ]  &&
while read -r pipe; do
  params+=("${pipe}")
done                  ||
[ ! -p '/dev/fd/0' ]  ||
{ printf 'Failed to process pipe\n' >&2; return 1; }

# Reset positional parameters to arguments without subcommands or flags
set -- "${params[@]-}"  ||
{ printf 'Failed to set parameters\n' >&2; return 1; }

return 0
