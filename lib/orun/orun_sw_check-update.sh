# CHECK   Software updates
# WARNING Cross-platform package manager update failure
# NOTICE  Redirected stdout of update commands
########################################################################

#TODO exit 3 if updates are available

# Cross-platform package managers
for pm in 'snap' 'flatpak' 'brew'; do
  command -v  snap >/dev/null                           &&
  { printf    '%s' "sw_check-update_${pm}"              |
      "${_script_wrapper[@]}"                           >&"${_notice}"  &&
    printf    '%s successfully checked for updates.\n'  \
              "${pm}"                                   >&"${_info}"    ||
    { declare return_code="${?}"
      printf  '%s is installed but checking for updates failed.\n'  \
              "${pm}"                                   >&"${warning}"
    }
  } || : # $pm not available, continue
done                                                    &&

# Native OS updaters
for os in 'rhel' 'deb' 'freebsd' 'mac'; do
  printf  '%s' "sw_check-update_${os}.sh"               |
    "${_script_wrapper[@]}"                             >&"${_notice}"  &&
  printf  'Updates checked for %s OS'                   \
          "${os}"                                       >&"${_info}"
done                                                    ||

return 1

return "${return_code-0}"
