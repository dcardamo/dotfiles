#!/bin/sh -e

if [ "$(uname)" = "Darwin" ]; then
  # Update the determinate systems nix installer
  sudo -i determinate-nixd upgrade

  echo "Updating homebrew"
  /opt/homebrew/bin/brew analytics off
  /opt/homebrew/bin/brew bundle
  /opt/homebrew/bin/brew update
  /opt/homebrew/bin/brew bundle --force cleanup

  # Commenting this out because mas is broken on mac 26
  #echo "Updating app store apps"
  #/opt/homebrew/bin/mas upgrade
fi

echo "Update nix system"
nix-channel --update
nix flake update

# Navigate to the directory of this script
cd $(dirname $(readlink -f $0))
cd ..
./bin/update.sh

