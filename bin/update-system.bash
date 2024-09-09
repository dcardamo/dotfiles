#!/bin/sh -e

if [ "$(uname)" = "Darwin" ]; then
  # Update the determinate systems nix installer
  sudo -i nix upgrade-nix

  echo "Updating homebrew"
  /opt/homebrew/bin/brew analytics off
  /opt/homebrew/bin/brew bundle
  /opt/homebrew/bin/brew update
  /opt/homebrew/bin/brew bundle --force cleanup

  echo "Updating app store apps"
  /opt/homebrew/bin/mas upgrade
fi

echo "Update nix system"
nix-channel --update
nix flake update


