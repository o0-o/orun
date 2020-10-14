# CHECK   Software updates in FreeBSD
# STDOUT  Available updates
# STDERR  Redirected stdout from metadata update
########################################################################

sudo pkg update  >&2  &&
pkg upgrade --dry-run ||
#pkg upgrade -n

return 1

return 0
