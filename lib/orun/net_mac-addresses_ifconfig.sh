# STDOUT  Mac addresses
########################################################################

ifconfig                              |
  sed -n                              \
      -e  '/^[[:space:]]ether / {
            s/^[[:space:]]ether //
            p
          }'                          |
  sort                                |
  uniq                                ||

return 1

return 0
