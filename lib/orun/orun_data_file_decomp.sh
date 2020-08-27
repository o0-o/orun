# Decompress a file

for FILE in "${VALS[@]-}"; do
  source "${__LIB_PATH}/data_file_decomp_tar.sh"        ||
  source "${__LIB_PATH}/data_file_decomp_gzip.sh"       ||
  source "${__LIB_PATH}/data_file_decomp_zip.sh"        ||
  source "${__LIB_PATH}/data_file_decomp_bzip2.sh"      ||
  source "${__LIB_PATH}/data_file_decomp_xz.sh"         ||
  source "${__LIB_PATH}/data_file_decomp_lzip.sh"
done  ||

return 1

return 0
