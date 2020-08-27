# Decompress a file with gzip

gzip --decompress -- "${FILE}"  || # --quiet also suppresses non-zero exit

# equivalent
#gunzip -- "${FILE}"             ||

return 1

return 0
