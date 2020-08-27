# Convert to lower case

for VAL in "${VALS[@]-}"; do
  source "${__LIB_PATH}/data_str_lcase.sh"
done  ||

return 1

return 0
