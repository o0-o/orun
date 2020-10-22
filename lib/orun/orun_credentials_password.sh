# STDOUT  Password for --account ($1) and --uri ($2) in macOS Keychain
########################################################################

: ${account:=$1}  && shift  || :
: ${uri:=$1}      && shift  || :

"${_script_wrapper[@]}"     ||

return 1

return 0
