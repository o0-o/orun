# COPY    --file or all positional parameters renamed with --prefix and
#         --suffix in the same directory
#         --prefix default is a period
#         --suffix default is a timestamp followed by a tilde
# RETURN  First code over 0 from the copy command
# NOTICE  Copy operations
# INFO    Summary
########################################################################

: ${prefix:=.}
: ${suffix:=.$("${_run}" time now --format '%Y%m%d%H%M%S')~}
declare failures='0'

set -- "${@-$file}"

for file; do

  declare target="$(dirname "${file}")/${prefix}${file##*/}${suffix}"

  # Backup $file to $target
  "${_script_wrapper[@]}"                         >&"${_notice}"  ||
  { : ${_return_code:=$?}
    (( failures = ${failures} + 1 ))
    printf  'Failed to copy %s to %s\n'           \
            "${file}"                             \
            "${target}"                           >&"${_warning}"
  }

done                                              ||

return 1

printf    '%s files copied, %s failures\n'        \
          "$(( ${#} - ${failures} ))"             \
          "${failures}"                           >&"${_info}"

return "${_return_code-0}"
