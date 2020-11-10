# STDOUT  Mac address(ss) with $upper_attribute or $lower_attribute
########################################################################

# Try ifconfig but fallback to nmcli for Linux OS's without ifconfig
{ ifconfig -a || nmcli device show; } |
# We can parse both ifconfig and nmcli output in one sed command
sed -n                                \
    -E                                \
    -e  '/('"${upper_attribute}"'|'"${lower_attribute}"')/ {
          :loop
            /^[[:space:]]*ether/ {
              s/^[[:space:]]*ether ([[:xdigit:],:]*).*$/\1/
              p
            }
            /^GENERAL\.HWADDR:/ {
              s/^.*[[:space:]]//
              p
            }
            n
          /^[[:space:]]/ b loop
          /^[[:upper:]]/ b loop
        }'                            &&

# Try ifconfig but fallback to nmcli for Linux OS's without ifconfig
{ ifconfig -a || nmcli device show; } |
# Reverse line order with tac (Linux) or tail-r (BSD)
{ tac         || tail -r;           } |
# We can parse both ifconfig and nmcli output in one sed command
sed -n                                \
    -E                                \
    -e  '/('"${upper_attribute}"'|'"${lower_attribute}"')/ {
         :loop
            /^[[:space:]]*ether/ {
              s/^[[:space:]]*ether ([[:xdigit:],:]*).*$/\1/
              p
            }
            /^GENERAL\.HWADDR:/ {
              s/^.*[[:space:]]//
              p
            }
          /^[[:space:]]/ {
            n
            b loop
          }
          /^[[:upper:]]/ {
            n
            b loop
          }
        }'                            ||

return 1

return 0
