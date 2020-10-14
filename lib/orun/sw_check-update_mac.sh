# CHECK   Software updates in macOS
# STDOUT  Available updates
########################################################################

softwareupdate --list ||
#softwareupdate -l

# mas is a command-line interface for the Mac App Store (optional)
mas outdated          ||
# If mas is not installed, exit code is 127 (command not found)
[ "${?}" -eq '127' ]  ||

return 1

return 0
