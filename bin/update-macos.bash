#!/bin/bash

echo "Update nix system"
sudo -i nix upgrade-nix
nix-channel --update

echo "Update homebrew"
/opt/homebrew/bin/brew analytics off
/opt/homebrew/bin/brew bundle
/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew bundle --force cleanup
/opt/homebrew/bin/mas upgrade
