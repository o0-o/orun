# STDOUT  Mac address(es) with $attribute
########################################################################

ifconfig -a                                           |
  tee                                                 \
    >(  sed -n                                        \
            -e '/'"${attribute//\./\\.}"'/ {
                  :loop
                    /^[[:space:]]*ether / {
                      s/^[[:space:]]*ether //
                      p
                    }
                    n
                  /^[[:alnum:]]/! b loop
                }'
    )                                                 \
    >(  $( command which tac || echo 'tail -r' )      |
          sed -n                                      \
              -e '/'"${attribute//\./\\.}"'/ {
                    :loop
                      n
                      /^[[:space:]]*ether / {
                        s/^[[:space:]]*ether //
                        p
                      }
                    /^[[:alnum:]]/! b loop
                  }'
    )                                                 >/dev/null &&
wait                                                  ||

return 1

return 0
