# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  vars,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
      # Trust the user to use restricted settings
      trusted-users = [
        "root"
        "dan"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  networking.hostName = "arcee";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Canada/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dan = {
    isNormalUser = true;
    description = "Dan Cardamore";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = vars.authorizedSshKeys;
  };

  environment.systemPackages = with pkgs; [
    ethtool
    helix
    gitMinimal
    docker-compose
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  programs.fish.enable = true;
  programs.mosh.enable = true;
  programs.zsh.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server"; # Enables IP forwarding automatically
    authKeyFile = "/run/secrets/tailscale-auth"; # Required for extraUpFlags to work
    extraUpFlags = [
      "--advertise-routes=10.0.0.0/24"
      "--accept-routes"
      "--advertise-exit-node" # This makes it an exit node
    ];
  };

  # Tailscale UDP optimizations for exit nodes/subnet routers
  # https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration
  systemd.services.tailscale-udp-optimizations = {
    description = "Tailscale UDP optimizations for exit nodes";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "tailscale-udp-opt" ''
        NETDEV=$(${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | cut -f 5 -d " ")
        if [ -n "$NETDEV" ]; then
          ${pkgs.ethtool}/bin/ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off
          echo "Applied UDP optimizations to $NETDEV"
        else
          echo "Could not determine network device"
          exit 1
        fi
      '';
    };
  };

  # Essential networking configuration
  # networking.firewall = {
  #   enable = true;
  #   trustedInterfaces = [ "tailscale0" ];
  #   checkReversePath = "loose";  # Critical for routing features
  # };

  virtualisation.docker.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
