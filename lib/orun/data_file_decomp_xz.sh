# Decompress an file with xz

xz      --quiet --decompress -- "${FILE}"               ||
unxz    --quiet -- "${FILE}"                            ||
xz      --quiet --decompress --format=lzma -- "${FILE}" ||
lzma    --quiet --decompress -- "${FILE}"               ||
unlzma  --quiet -- "${FILE}"                            ||

return 1

return 0
