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

1. Boot into a new nixos installer
2. Partition and format drives: https://nixos.wiki/wiki/NixOS_Installation_Guide

   Format UEFI

   ```
   sudo fdisk /dev/diskX
   g (gpt disk label)
   n
   1 (partition number [1/128])
   2048 first sector
   +500M last sector (boot sector size)
   t
   1 (EFI System)
   n
   2
   default (fill up partition)
   default (fill up partition)
   w (write)
   # REPEAT FOR EXTRA DRIVES
   ```

   Label partitions and format:

   ```
   lsblk
   sudo mkfs.fat -F 32 /dev/sdX1
   sudo fatlabel /dev/sdX1 NIXBOOT
   sudo mkfs.ext4 /dev/sdX2 -L NIXROOT
   sudo mount /dev/disk/by-label/NIXROOT /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
   # DO OTHER EXTRA DRIVES ALSO
   ```

   Swap file:

   ```
   sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152 (2GB size)
   sudo chmod 600 /mnt/.swapfile
   sudo mkswap /mnt/.swapfile
   sudo swapon /mnt/.swapfile
   ```

3. Generate the nixos configuration files in /mnt/etc/nix. Copy them to this project:
   `sudo nixos-generate-config --root /mnt`
4. Copy github valid ssh keys to the machine so it can checkout the repository:
   On the new machine:
   set a password for the nixos user on the remote machine: `passwd`
   On a working machine to setup the new machine:
   `scp ~/.ssh/id_ed25519* nixos@<ipofnewmachine>:.ssh/`
   On the new machine again:
   ```
   nix-shell -p git helix
   cd ~
   git clone git@github.com:dcardamo/dotfiles.git
   ```
   Replace the hardware-configuration.nix file with the one generated:
   ```
   cp /mnt/etc/nixos/hardware-configuration.nix dotfiles/nixos/<new machine hostname>/
   ```
5. install the machine:
   ```
     cd ~/dotfiles
     sudo nixos-install --flake .#<new machine host name>
   ```
6. Before rebooting into the new system, git push the changes:
   ```
      git config --global user.email "dan@hld.ca"
      git config --global user.name "Dan Cardamore"
      git commit -m "installed new system <hostname>"
      git push origin
   ```
7. after reboot: `sudo passwd dan`

## Influences

- https://github.com/mrjones2014/dotfiles
- https://github.com/treffynnon/nix-setup
- https://github.com/fufexan/dotfiles
- https://gitlab.com/hmajid2301/dotfiles
