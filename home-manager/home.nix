# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in
{
  nixpkgs = {
    config = {
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

  home.packages =
    lib.lists.optionals isDarwin [
      # put macOS specific packages here
      # TODO
    ]
    ++ lib.lists.optionals isLinux [
      #put Linux specific packages here
    ];

  # You can import other home-manager modules here
  imports = [
    ./modules/base.nix
    ./modules/ripgrep.nix
    ./modules/bat.nix
    ./modules/dev.nix
    ./modules/devenv.nix
    #./modules/elixir.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/helix
    ./modules/nodejs.nix
    ./modules/python.nix
    ./modules/ssh.nix
    # ./modules/starship
    # ./modules/tmux.nix
    ./modules/wezterm.nix
    ./modules/zed
    ./modules/zellij.nix
    ./modules/zsh.nix
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
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
