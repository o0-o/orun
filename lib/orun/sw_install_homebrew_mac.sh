# Install Homebrew
# This process is interactive

xcode-select --install  &&
bash -c \
  "$( curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/master/install.sh
  )"                    ||

return 1

return 0
