# Check for software updates

source "${__LIB_PATH}/sw_check-update_rhel.sh"    ||
source "${__LIB_PATH}/sw_check-update_deb.sh"     ||
source "${__LIB_PATH}/sw_check-update_freebsd.sh" ||
source "${__LIB_PATH}/sw_check-update_mac.sh"     ||

return 1

return 0
