# CHECK   Software updates in Red Hat-based Linux Distributions
# STDOUT  Available updates
########################################################################

# Fedora and versions 8+ of CentOS/RHEL
sudo dnf check-update ||
# Exits 100 when updates are available
[ "${?}" -eq '100' ]  ||

# Earlier versions of CentOS/RHEL
sudo yum check-update ||
# Exits 100 when updates are available
[ "${?}" -eq '100' ]  ||

return 1

return 0
