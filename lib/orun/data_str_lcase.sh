# Convert to lower case

printf '%s\n' "${VAL}"  |
tr '[A-Z]' '[a-z]'  ||

return 1

return 0
