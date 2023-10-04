#!/usr/bin/env bash

set -ex

sudo nix-channel --update
sudo nixos-rebuild switch --upgrade --flake ~/git/dotfiles/.#beast
