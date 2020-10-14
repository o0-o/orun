# STDOUT  A new uuid in lowercase
########################################################################

"${_script_wrapper[@]}" | "${_run}" str lcase  ||

return 1

return 0
