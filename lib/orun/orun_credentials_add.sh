# CREATE  Entry for --account ($1), --uri ($2) and --password ($3) in
#         macOS Keychain
########################################################################

: ${account:=$1}  && shift                          || :
: ${uri:=$1}      && shift                          || :
: ${password:=$1} && shift                          || :

# Remove conflicting entry
"${_run}" credentials delete "${account}" "${uri}"  &&
printf  'Updating credentials for %s@%s\n'          \
        "${account}"                                \
        "${uri}"                                    >&"${_info}" || :

"${_script_wrapper[@]}"                             ||

return "${?}"

printf  '%s@%s added to keychain\n'                 \
        "${account}"                                \
        "${uri}"                                    >&"${_info}"

return 0
