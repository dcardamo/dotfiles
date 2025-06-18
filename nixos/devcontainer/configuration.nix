# NixOS configuration for development containers
{ config, pkgs, lib, ... }:

{
  # Basic system configuration
  system.stateVersion = "24.05";
  
  # Boot configuration for containers
  boot.isContainer = true;
  
  # Networking
  networking = {
    hostName = "devcontainer"; # Will be overridden by container name
    firewall.enable = false; # OrbStack handles this
    # Enable IPv6
    enableIPv6 = true;
  };

  # Time zone
  time.timeZone = "America/New_York";

  # User configuration
  users.users.dan = {
    isNormalUser = true;
    uid = 501; # macOS default UID
    group = "staff";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    # Password disabled - access via docker exec only
    hashedPassword = "!";
    
    # Create necessary directories
    createHome = true;
    home = "/home/dan";
  };

  users.groups.staff = {
    gid = 20; # macOS staff group GID
  };


  # Basic packages needed for container operation
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    rsync
    # Add home-manager for manual operations
    home-manager
  ];

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "dan" ];
      # Optimize storage
      auto-optimise-store = true;
    };
    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Disable documentation to save space
  documentation.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;
  
  # Minimal services for containers
  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=8M
  '';
  
  # Systemd configuration for containers
  systemd.services."systemd-networkd-wait-online".enable = lib.mkForce false;
  
  # Mount points for OrbStack
  fileSystems."/home/dan/git" = {
    device = "/home/dan/git";
    fsType = "none";
    options = [ "bind" "defaults" "nofail" ];
  };
  
}