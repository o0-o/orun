# Print the current kernel name and version

printf '%s\t%s\t%s\n'                                 \
  "$(source "${__LIB_PATH}/orun_sw_kernel_name.sh")"  \
  "$(source "${__LIB_PATH}/orun_hw_arch.sh")"         \
  "$(source "${__LIB_PATH}/orun_sw_kernel_version.sh")" ||

return 1

return 0
