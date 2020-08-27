# Decompress a file with bzip2

bzip2 --quiet --decompress -- "${FILE}" ||
bunzip2 --quiet -- "${FILE}"            ||

return 1

return 0
