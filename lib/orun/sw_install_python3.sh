#
# Install Python 3

# Check for most recent software available
source "${__LIB_PATH}/orun_sw_check-update"   &&

# Install Python 3 on this system
source "${__LIB_PATH}/install_python3_rhel.sh"  ||
source "${__LIB_PATH}/install_python3_deb.sh"   ||
source "${__LIB_PATH}/install_python3_bsd.sh"   ||
source "${__LIB_PATH}/install_python3_mac.sh"   ||

return 1

return 0
