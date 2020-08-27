# Extract and decompress a tar file with xz

tar --extract --file --xz     -- "${FILE}"  ||
tar --extract --file --gzip   -- "${FILE}"  ||
tar --extract --file --bzip2  -- "${FILE}"  ||

return 1

return 0
