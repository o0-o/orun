# Check for software updates on Red Hat, CentOS or Fedora Linux

# Fedora and recent versions of CentOS/RHEL
sudo dnf check-update ||

# Earlier versions of CentOS/RHEL
sudo yum check-update ||

return 1

return 0
