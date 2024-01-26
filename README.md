# Dan's configuration as a nix Flake for darwin and maybe NixOS/Linux too

## Installation
Make sure that this repo is checked out first to ~/git/dotfiles
First, if on Mac, symlink the Brewfile.$HOSTNAME to Brewfile so that the
right one gets used.

`ln -sf Brewfile.$HOSTNAME Brewfile`

Then install all dependencies:
```
make install
```

## Update
```
make update
```

## Inspiration
* https://github.com/mrjones2014/dotfiles
* https://github.com/treffynnon/nix-setup
* https://github.com/fufexan/dotfiles
* https://gitlab.com/hmajid2301/dotfiles
* vim config: https://github.com/siph/nixvim-flake/blob/master/flake.nix
