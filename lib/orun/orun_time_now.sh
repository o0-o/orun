# STDOUT    Current date and/or time in --format, $1 or default
# REFERENCE https://man.openbsd.org/strftime.3
########################################################################

: ${format:=$1}
: ${format:=%Y-%m-%d_%H-%M-%S}

"${_script_wrapper[@]}" ||

return 1

return 0
