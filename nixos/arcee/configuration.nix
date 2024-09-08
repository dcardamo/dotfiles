# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ modulesPath, config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../container-services.nix
    ./container-service-hass.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.hostName = "pluto";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  time.timeZone = "Canada/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dan = {
    isNormalUser = true;
    description = "Dan Cadramore";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      # dan ipad m4 pro:
      ''
        ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJ0uue7ICe3WJiXuKbFlsO9kZY+Az6TCDrn67Tl/KReHJPq4V86XdihWCG08IFUqSFzBqIC8zw6rmVJ+rduTYDU= dan@ipad
      ''
      # mac laptop mars
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe+4bVpPWZTF344M5TRzaz5/90s5finWdYFXhs+mwac dan@dans-mbp.lan"
      # dan iphone 15 pro
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEaCACN0Pby6uZWYBZ3umr8SCobH6OQgQ5gYs7IQUM55kiTY0A+l5HJ7FYKNUcYXq+HPbwkZ33ixjkfaZc99OTU= dan@iphone"
    ];
    packages = with pkgs; [ ];
  };

  environment.systemPackages = with pkgs; [ helix gitMinimal ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  programs.fish.enable = true;
  programs.mosh.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}

