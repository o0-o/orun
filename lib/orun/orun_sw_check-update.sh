# Check for software updates

source "${__LIB_PATH}/check-update_rhel.sh" ||
source "${__LIB_PATH}/check-update_deb.sh"  ||
source "${__LIB_PATH}/check-update_bsd.sh"  ||
source "${__LIB_PATH}/check-update_mac.sh"  ||

return 1

return 0
