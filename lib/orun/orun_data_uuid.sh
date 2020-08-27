# Generate a UUID

source "${__LIB_PATH}/data_uuid.sh" |
"${__RUN}" data str lcase || #standardize on lower-case

return 1

return 0
