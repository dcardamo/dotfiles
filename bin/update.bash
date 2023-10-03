#!/bin/sh -e

GREEN='\033[1;32m'
RED='\033[1;31m'
CLEAR='\033[0m'

# Navigate to the directory of this script
cd $(dirname $(readlink -f $0))
cd ..

export NIXPKGS_ALLOW_UNFREE=1

darwin_build() {
    echo "${GREEN}Building for darwin...${CLEAR}"
    home-manager switch --flake ~/git/dotfiles/.#mac
    echo "${GREEN}Done${CLEAR}"
}

if [ "$(uname)" == "Darwin" ]; then
    darwin_build
    echo "Update homebrew"
    /opt/homebrew/bin/brew analytics off
    /opt/homebrew/bin/brew bundle
    /opt/homebrew/bin/brew update
    /opt/homebrew/bin/brew bundle --force cleanup
    /opt/homebrew/bin/mas upgrade
elif [ "$(uname)" == "Linux" ]; then
    echo "${GREEN}Building for nixos...${CLEAR}"
    sudo nixos-rebuild switch --flake ~/git/dotfiles/.#beast
else
    echo "${RED}Unknown platform${CLEAR}"
fi
