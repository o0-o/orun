# STDOUT    Current date and/or time in $format
# REFERENCE https://man.openbsd.org/strftime.3
########################################################################

date  "+${format}"  ||

return 1

return 0
