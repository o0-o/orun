# COPY    $file to $target, don't overwrite
# STDOUT  Copy operation
########################################################################

# Linux
cp  --no-clobber              \
    --preserve=all            \
    --verbose                 \
    -- "${file}" "${target}"  ||

# BSD
cp  -n                        \
    -p                        \
    -v                        \
    -- "${file}" "${target}"  ||

return 1

return 0
