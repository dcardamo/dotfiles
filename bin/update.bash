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
    FLAKE="mac"
    SYSTEM="homeConfigurations.$FLAKE.pkgs"
    echo "${GREEN}Starting build...${CLEAR}"
    nix --experimental-features 'nix-command flakes' build .#$SYSTEM --impure $@
    echo "${GREEN}Switching to new generation...${CLEAR}"
    ./result/sw/bin/darwin-rebuild switch --flake .#$FLAKE --impure $@
    echo "${GREEN}Cleaning up...${CLEAR}"
    unlink ./result
    echo "${GREEN}Done${CLEAR}"
}

if [ "$(uname)" == "Darwin" ]; then
    darwin_build $@
elif [ "$(uname)" == "Linux" ]; then
    echo "${GREEN}Building for nixos...${CLEAR}"
    sudo nixos-rebuild switch --flake ~/git/dotfiles/.#pc
else
    echo "${RED}Unknown platform${CLEAR}"
fi
