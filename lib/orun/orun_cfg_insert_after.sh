# Insert after regex once

local -r   RE="${VALS[0]-}" &&
local -r  STR="${VALS[1]-}" &&
local -r FILE="${VALS[2]-}" &&

sed -E -e '
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
