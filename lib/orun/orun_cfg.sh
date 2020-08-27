# Apply configuration
# orun cfg '/etc/conf.cfg' 'interface' 'eth0' ' = ' '#' '# INTERFACES'

local -r         FILE="${VALS[0]}"                                &&
local -r        PARAM="${VALS[1]}"                                &&
local -r        VALUE="${VALS[2]}"                                &&
local -r ASSIGN_DELIM="${VALS[3]-=}"                              &&
local -r      COMMENT="${VALS[4]-#}"                              &&
local  DEFAULT_A_RE="^[[:space:]]*${COMMENT}+[[:space:]]*"        &&
         DEFAULT_A_RE="${DEFAULT_A_RE}${PARAM}${ASSIGN_DELIM}.*$" &&
local -r     AFTER_RE="${VALS[5]-$DEFAULT_A_RE}"                  &&
local -r         ASSEMBLED="${PARAM}${ASSIGN_DELIM}${VALUE}"      &&

# Check if configuration is already set
{ "${__RUN}" cfg contains "^${ASSEMBLED}$" "${FILE}"  &&
  printf "'%s' already in %s\n" \
    "${ASSEMBLED}" "${FILE}" 1>&3
}                                                                 ||

# Otherwise, attempt to insert after supplied regex
{ [ ! -z "${AFTER_RE-}" ]                                             &&
  "${__RUN}" cfg insert after "${AFTER_RE}" "${ASSEMBLED}" "${FILE}"  &&
  "${__RUN}" cfg contains "^${ASSEMBLED}$" "${FILE}"                  &&
  printf "'%s' inserted after '%s' in %s\n" \
    "${ASSEMBLED}" "$(egrep -m 1 "${AFTER_RE}" "${FILE}")" "${FILE}" >&3
}                                                                 ||

# Otherwise, append to the end of the file
{ printf '%s\n' "${ASSEMBLED}" >> "${FILE}"  &&
  printf '%s\n' "'${ASSEMBLED}' appended to ${FILE}" >&3
}                                                                 ||

return 1

return 0
