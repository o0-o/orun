# STDOUT  Interface(s) with --attribute ($1)
########################################################################

[ ! -z "${1-}" ]                                                  &&
: ${attribute:=$1}
# Default if no value is provided (all addresses are printed)
: ${attribute:=[[:print:]]*}
# Escape periods for ip addresses
declare attribute="${attribute//\./\\.}"                          &&
declare upper_attribute="$( "${_run}" str ucase "${attribute}" )" &&
declare lower_attribute="$( "${_run}" str lcase "${attribute}" )" &&

"${_script_wrapper[@]}"       ||

return 1

return 0
