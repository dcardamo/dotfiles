#!/bin/sh -e

GREEN='\033[1;32m'
RED='\033[1;31m'
CLEAR='\033[0m'

# Navigate to the directory of this script
cd $(dirname $(readlink -f $0))
cd ..

export NIXPKGS_ALLOW_UNFREE=1

nix-channel --update

if [ "$(uname)" == "Darwin" ]; then
    home-manager switch --flake ~/git/dotfiles/.#mac
elif [ "$(uname)" == "Linux" ]; then
    sudo nixos-rebuild switch --flake ~/git/dotfiles/.#$(hostname)
else
    echo "${RED}Unknown platform${CLEAR}"
fi
