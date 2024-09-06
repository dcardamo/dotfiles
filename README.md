# Dan's configuration as a nix Flake for darwin and maybe NixOS/Linux too

## Installation MacOS
Make sure that this repo is checked out first to ~/git/dotfiles
First, if on Mac, symlink the Brewfile.$HOSTNAME to Brewfile so that the
right one gets used.

`ln -sf Brewfile.$HOSTNAME Brewfile`

Then install all dependencies:
```
make install
```

Add self to trusted-users list in /etc/nix/nix.conf
```
trusted-users = root dan

sudo pkill nix-daemon
```

## Update
```
make update
```

## Installation on a new NixOS machine
Using nix-anywhere:
https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md
https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/no-os.md#installing-on-a-machine-with-no-operating-system

1. Boot into a new nixos installer
2. Partition and format drives:  https://nixos.wiki/wiki/NixOS_Installation_Guide
3. Generate the nixos configuration files in /mnt/etc/nix.   Copy them to this project:
  `nixos-generate-config --no-filesystems --dir /mnt`
4. Copy an ssh key onto the system that has access to github and then clone this repo
5. install the machine:
    pluto:
    ```
      sudo nixos-install --flake .#pluto
    ```

### nix-anywhere notes
I tried to set pluto up with nix-anywhere but didn't have success because darwin couldn't build linux binaries.
So the current system requires setup like above.

## Inspiration
* https://github.com/mrjones2014/dotfiles
* https://github.com/treffynnon/nix-setup
* https://github.com/fufexan/dotfiles
* https://gitlab.com/hmajid2301/dotfiles
* vim config: https://github.com/siph/nixvim-flake/blob/master/flake.nix
