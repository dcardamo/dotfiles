# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  vars,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # AMD GPU support for Radeon 8060S
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  # Graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # OpenCL/ROCm support for AI workloads
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
    ];
  };

  # Performance tuning for Ryzen AI Max 395
  powerManagement.cpuFreqGovernor = "performance";

  # Enable microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      # Trust the user to use restricted settings
      trusted-users = [ "root" "dan" ];
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

  networking.hostName = "neptune";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Firewall configuration
  networking.firewall = {
    enable = true;  # Firewall is enabled by default, but being explicit
    allowedTCPPorts = [ 3008 3010 ];
  };

  time.timeZone = "Canada/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.dan = {
    isNormalUser = true;
    description = "Dan Cardamore";
    shell = pkgs.zsh;
    extraGroups = ["wheel" "video" "audio" "networkmanager" "ollama" "docker"]; # Enable 'sudo' and hardware access
    openssh.authorizedKeys.keys = vars.authorizedSshKeys;
  };

  environment.systemPackages = with pkgs; [
    ethtool
    helix
    gitMinimal
    wget
    curl
    htop
    btop
    neofetch
    pciutils
    usbutils
    docker-compose
  ];

  # Enable firmware updates
  services.fwupd.enable = true;

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

  # Audio support
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Ollama service for local LLM inference
  services.ollama = {
    enable = true;
    # acceleration = "rocm";  # Use AMD GPU acceleration
    loadModels = [ ];  # Models already downloaded

    # Environment variables for better AMD GPU support
    environmentVariables = {
      OLLAMA_NUM_GPU = "999";  # Use all available GPU layers
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";  # May be needed for some AMD GPUs
    };
  };

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

  # Docker support
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    # Enable GPU support in Docker containers
    enableNvidia = false;
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
