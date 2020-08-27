# Insert string after regex match once

sed -e '
  /'"${RE}"'/ {
    a\
      '"${STR}"'
    :loop
      n
    b loop
    q
  }'  "${FILE}" |
  tee "${FILE}" >/dev/null ||

return 1

return 0
