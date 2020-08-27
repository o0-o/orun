# Convert to lower case

printf '%s\n' "${VAL}"  |
tr '[a-z]' '[A-Z]'  ||

return 1

return 0
