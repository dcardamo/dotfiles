#!/bin/sh -e

GREEN='\033[1;32m'
RED='\033[1;31m'
CLEAR='\033[0m'

if [ "$(uname)" == "Darwin" ]; then
    echo "${GREEN}Building for darwin...${CLEAR}"
    home-manager switch --flake ~/git/dotfiles/.#mac
elif [ "$(uname)" == "Linux" ]; then
    echo "${GREEN}Building for nixos...${CLEAR}"
    sudo nixos-rebuild switch --flake ~/git/dotfiles/.#pc
else
    echo "${RED}Unknown platform${CLEAR}"
fi
