# STDOUT  Kernel name, hardware architecture and kernel version
########################################################################

printf  '%s\t%s\t%s\n'                                          \
  "$( printf  'sw_kernel_name'    | "${_script_wrapper[@]}" )"  \
  "$( printf  'hw_architecture'   | "${_script_wrapper[@]}" )"  \
  "$( printf  'sw_kernel_version' | "${_script_wrapper[@]}" )"  ||

return 1

return 0
