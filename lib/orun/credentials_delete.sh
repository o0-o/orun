# DELETE  Entry for $account and $uri in macOS Keychain
########################################################################

security  delete-generic-password \
          -a  "${account}"        \
          -s  "${uri}"            >/dev/null ||

return "${?}"

return 0
