declare debug_parameter_format='%13s = %s\n'
printf    '%s\n'                                        \
          '-------------------------------------------' \
          '|      ____     ___     __  __   _  __    |' \
          '|     / __ \   / _ \   / / / /  / |/ /    |' \
          '|    / /_/ /  / , _/  / /_/ /  /    /     |' \
          '|    \____/  /_/|_|   \____/  /_/|_/      |' \
          '|                                         |' \
          '-------------------------------------------' \
          '|  D        E        B        U        G  |' \
          '-------------------------------------------' >&2
printf    "${debug_parameter_format}"                   \
          'shell'       "${_sh}"                        \
          'path'        "${PATH}"                       \
          'current dir' "${_cd}"                        \
          'bin'         "${_bin_path}"                  \
          'tmp'         "${_tmp_path}"                  \
          'verbosity'   "${verbosity}"                  \
          'syslog'      "${syslog}"                     \
          'log level'   "${log_level}"                  >&"${_debug}"
declare i='1' && for param; do
  printf  "${debug_parameter_format}"                   \
          "\$${i}"      "${param}"                      >&"${_debug}"
  ((i++))
done
printf    "${debug_parameter_format}"                   \
          'stdout'      "FD${_stdout}"                  \
          'stdout alt'  "FD${_stdout_alt}"              \
          'stderr'      "FD${_stderr}"                  \
          'stderr alt'  "FD${_stderr_alt}"              >&"${_debug}"
printf    "${debug_parameter_format}"                   \
          "${level}" "FD${fd-/dev/null}"                >&"${_debug}"
