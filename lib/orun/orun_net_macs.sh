# STDOUT  Mac address(es) with --attribute ($1)
########################################################################

# User $1 if it exists and --attribute isn't set
[ ! -z "${1-}" ]                                                          &&
: ${attribute:=$1}
# Use upper and lower-case versions and escape periods for ip addresses
[ ! -z "${attribute-}" ]                                                  &&
declare upper_attribute="$( "${_run}" str ucase "${attribute//\./\\.}" )" &&
declare lower_attribute="$( "${_run}" str lcase "${attribute//\./\\.}" )"
# Default if no value is provided (all addresses are printed)
: ${upper_attribute:=[[:print:]]*}
: ${lower_attribute:=[[:print:]]*}

"${_script_wrapper[@]}" | sort  | uniq                                    ||

return 1

return 0
