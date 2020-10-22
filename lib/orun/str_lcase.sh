# STDOUT  $string in lower case
########################################################################

printf  '%s\n'                          \
        "${string}"                     |
        tr '[[:upper:]]' '[[:lower:]]'  ||
#echo "${string}" | tr '[A-Z]' '[a-z]'
#echo "${string,,}" #bash
#echo "${string:l}" #zsh

return 1

return 0
