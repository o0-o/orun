# Check for software updates on Red Hat, CentOS or Fedora Linux

# Fedora and recent versions of CentOS/RHEL
{ sudo dnf check-update ||
  # exits 100 when updates are available
  [ "$?" -eq '100' ]
} ||

# Earlier versions of CentOS/RHEL
{ sudo yum check-update ||
  # exits 100 when updates are available
  [ "$?" -eq '100' ]
} ||

return 1

return 0
