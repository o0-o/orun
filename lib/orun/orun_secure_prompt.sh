# STDIN   Secure string via TTY prompt
# STDOUT  String from stdin
########################################################################

: ${prompt:=$@}
: ${prompt:=Password}

"${_script_wrapper[@]}"                 ||

return 1

return 0
