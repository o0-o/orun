# CREATE  Entry for $account $uri and $password in macOS Keychain
########################################################################

security  add-generic-password    \
          -a  "${account}"        \
          -s  "${uri}"            \
          -w  "${password}"       ||

return "${?}"

return 0
