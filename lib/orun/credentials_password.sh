# STDOUT  Password matching $account and $uri in macOS Keychain
########################################################################

security  find-generic-password   \
          -a  "${account}"        \
          -s  "${uri}"            \
          -w                      ||

return "${?}"

return 0
