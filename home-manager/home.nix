# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      # allowUnfreePredicate = (_: true);
    };
  };

  # sourcehut is down on Jan 13, 2024.  So doing this workaround to remove documentation:
  # https://github.com/nix-community/home-manager/issues/4879
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

  home.username = "dan";
  home.homeDirectory = if isLinux then "/home/dan" else "/Users/dan";

  home.packages = with pkgs;
    [ spotify ] ++ lib.lists.optionals isDarwin [
      # put macOS specific packages here
      # TODO
    ] ++ lib.lists.optionals isLinux [
      #put Linux specific packages here
      vlc
    ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "discord"
      "1password"
      "1password-cli"
      # This is required for pkgs.nodePackages_latest.vscode-langservers-extracted on NixOS
      # however VS Code should NOT be installed on this system!
      # Use VS Codium instead: https://github.com/VSCodium/vscodium
      "vscode"
    ];

  # You can import other home-manager modules here
  imports = [
    ./modules/base.nix
    #inputs.nixvim.homeManagerModules.nixvim
    ./modules/lazyvim
    #./modules/nixvim.nix
    ./modules/helix.nix
    ./modules/fish.nix
    ./modules/fzf.nix
    ./modules/starship.nix
    ./modules/bat.nix
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/wezterm.nix
    ./modules/zellij
    ./modules/darwin/hammerspoon
    ./modules/devenv.nix
    ./modules/tmux.nix
  ];

  xdg.configFile = {
    "nix/nix.conf".text = ''
      experimental-features = nix-command flakes
      # see https://github.com/nix-community/nix-direnv#via-home-manager
      keep-derivations = true
      keep-outputs = true
    '';
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  # direnv integration for flakes
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
