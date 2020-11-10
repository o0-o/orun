# STDOUT  Interface(s) with $upper_attribute or $lower_attribute
########################################################################

# Try ifconfig but fallback to nmcli for Linux OS's without ifconfig
{ ifconfig -a || nmcli device show; } |
# Reverse line order with tac (Linux) or tail-r (BSD)
{ tac         || tail -r;           } |
# We can parse both ifconfig and nmcli output in one sed command
sed -n                                \
    -E                                \
    -e  '/('"${upper_attribute}"'|'"${lower_attribute}"')/ {
          :loop
            n
            /^[[:lower:]].*:/ {
              s/:.*$//
              p
            }
            /^GENERAL\.DEVICE:/ {
              s/GENERAL.DEVICE:[[:space:]]*//
              p
            }
          /^[[:space:]]/ b loop
          /^[[:upper:]]/ b loop
        }'                                  ||

return 1

return 0
