# Retrieve script name from pipe or derive from parent
[ -p '/dev/fd/0' ] && read -r script ||
: ${script:=$(  basename  "${funcsourcetrace[1]-$BASH_SOURCE[1]}" |
                  sed -e  's/:[[:digit:]]*$//'                    |
                  sed -e  "s/^${_name}_//"                        |
                  sed -e  's/\.[[:alpha:]]*$//'                       )}

# Execute first library match with a supported extension
for ext in "${exts_valid[@]}"; do
  [ -f "${_lib_path}/${script}.${ext}" ]    &&
  { case "${ext}" in

      'sh'  )
        { # Trace script unless it is $command_lib (goes to debug)
          [ "${script}" = "${command_lib}" ]  || set -x
          # Call the script
          source        "${_lib_path}/${script}.${ext}"
          declare wrapper_return="${?}"
          # Disable trace unless --trace or --verbosity=trace
          "${trace-false}"                    || set +x
          # May be called again, so reset $script
          unset script
        }
        # Return script exit code
        return "${wrapper_return}"
        ;;

      # Repeat for other supported languages
      'awk' )
        { [ "${script}" = "${command_lib}" ]  || set -x
          printf '%s\n' "${@}"  |
            awk   -f    "${_lib_path}/${script}.${ext}"
          declare wrapper_return="${?}"
          "${trace-false}"                    || set +x
          unset script
        }
        return "${wrapper_return}"
        ;;
      'tcl' )
        { [ "${script}" = "${command_lib}" ]  || set -x
          tclsh         "${_lib_path}/${script}.${ext}" "$@"
          declare wrapper_return="${?}"
          "${trace-false}"                    || set +x
          unset script
        }
        return "${wrapper_return}"
        ;;
      'pl'  )
        { [ "${script}" = "${command_lib}" ]  || set -x
          perl          "${_lib_path}/${script}.${ext}" "$@"
          declare wrapper_return="${?}"
          "${trace-false}"                    || set +x
          unset script
        }
        return "${wrapper_return}"
        ;;
      'py'  )
        { [ "${script}" = "${command_lib}" ]  || set -x
          "${_python}"  "${_lib_path}/${script}.${ext}" "$@"
          declare wrapper_return="${?}"
          "${trace-false}"                    || set +x
          unset script
        }
        return "${wrapper_return}"
        ;;
      'rb'  )
        { [ "${script}" = "${command_lib}" ]  || set -x
          ruby          "${_lib_path}/${script}.${ext}" "$@"
          declare wrapper_return="${?}"
          "${trace-false}"                    || set +x
          unset script
        }
        return "${wrapper_return}"
        ;;
    esac ||
    { printf 'Failed to execute: %s\n' "${script}.${ext}" >&"${_err}";
      return 1; }
  }                                         ||
  [ ! -f "${_lib_path}/${script}.${ext}" ]  ||
  { printf 'Error running %s.%s in wrapper\n' "${script}" "${ext}" >&"${_err}"
    return 1; }
done

{ printf '%s not found\n' "${script}" >&"${_err}"
  return "${_code_not_found}"; }
