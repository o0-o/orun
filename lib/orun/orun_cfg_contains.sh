# Returns 0 if regex is in file, otherwise returns 1

readonly   RE="${VALS[0]}"                  &&
readonly FILE="${VALS[1]}"                  &&

source "${__LIB_PATH}/cfg_contains_grep.sh" ||

return 1

return 0
