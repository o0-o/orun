# STDOUT  Default gateway interface
########################################################################

# BSD
route get default                       |
# route get -net 0.0.0.0
awk '/interface/ { print $2 }'          ||

# Linux
ip route show default                   |
sed 's/^.*dev \([[:alnum:]]*\).*$/\1/'  ||

return 1

return 0
