# CHECK   Software updates in Debian-based Linux distributions
# STDOUT  Available updates
# STDERR  Redirected stdout from metadata update
########################################################################

sudo apt-get update >&2 &&
#apt update

sudo apt-get  upgrade
              --show-upgraded
              --assume-no
#apt-get upgrade -u --assume-no
#apt list --upgradeable

return 1

return 0
