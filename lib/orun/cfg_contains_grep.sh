# Returns 0 if regex is in file, otherwise returns 1

egrep -q "${RE}" "${FILE}" ||

return 1

return 0
