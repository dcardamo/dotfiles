#!/bin/sh -e

# Navigate to the directory of this script
cd $(dirname $(readlink -f $0))
cd ..

export NIXPKGS_ALLOW_UNFREE=1

nix-channel --update

if [ "$(uname)" = "Darwin" ]; then
    home-manager switch --flake ~/git/dotfiles/.#mac
elif [ "$(uname)" = "Linux" ]; then
    sudo nixos-rebuild switch --flake ~/git/dotfiles/.#"$(hostname)"
else
    echo "Unknown platform"
    exit 1
fi

# Set up Claude MCP servers if Claude is configured
if [ -f ~/.config/claude/setup-mcp-servers.sh ]; then
    echo "Setting up Claude MCP servers..."
    ~/.config/claude/setup-mcp-servers.sh
fi
