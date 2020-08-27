# Check for software updates on macOS

softwareupdate -l &&
brew update       ||

return 1

return 0
