# Check for software updates on macOS

softwareupate -l  &&
brew update       ||

return 1

return 0
