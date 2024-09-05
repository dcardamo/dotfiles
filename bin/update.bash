#!/bin/sh -e

GREEN='\033[1;32m'
RED='\033[1;31m'
CLEAR='\033[0m'

# Navigate to the directory of this script
cd $(dirname $(readlink -f $0))
cd ..

export NIXPKGS_ALLOW_UNFREE=1

nix-channel --update

darwin_build() {
    echo "${GREEN}Building for darwin...${CLEAR}"
    home-manager switch --flake ~/git/dotfiles/.#mac
    echo "${GREEN}Done${CLEAR}"
}

if [ "$(uname)" == "Darwin" ]; then
    darwin_build
elif [ "$(uname)" == "Linux" ]; then
    echo "${GREEN}Building for nixos...${CLEAR}"
    if [ "$(hostname)" == "pluto" ]; then
        sudo nixos-rebuild switch --flake ~/git/dotfiles/.#$(hostname)
    else
        echo "${RED}Unknown hostname${CLEAR}"
    fi
else
    echo "${RED}Unknown platform${CLEAR}"
fi
