# DELETE  Entry for --account ($1) and --uri ($2) in macOS Keychain
########################################################################

: ${account:=$1}  && shift                    || :
: ${uri:=$1}      && shift                    || :

"${_script_wrapper[@]}"                       ||

return "${?}"

printf  '%s@%s deleted from from keychain\n'  \
        "${account}"                          \
        "${uri}"                              >&"${_info}"

return 0
