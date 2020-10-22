# STDOUT  $string in upper case
########################################################################

printf  '%s\n'                          \
        "${string}"                     |
        tr '[[:lower:]]' '[[:upper:]]'  ||
#echo "${string}" | tr '[a-z]' '[A-Z]'
#echo "${string^^}" #bash
#echo "${string:u}" #zsh

return 1

return 0
