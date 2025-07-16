# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
    };
  };

  # sourcehut is down on Jan 13, 2024.  So doing this workaround to remove documentation:
  # https://github.com/nix-community/home-manager/issues/4879
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

  home.username = "dan";
  home.homeDirectory =
    if isLinux
    then "/home/dan"
    else "/Users/dan";

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
    ./modules/claude.nix
    ./modules/dev.nix
    ./modules/devenv.nix
    ./modules/env-template.nix
    ./modules/fzf.nix
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/helix
    ./modules/neovim.nix
    ./modules/nodejs.nix
    ./modules/npm-packages.nix
    ./modules/python.nix
    ./modules/rust.nix
    ./modules/ssh.nix
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

  # Enable Claude configuration
  programs.claude = {
    enable = true;
    defaultModel = "opus";
    context7.enable = true;
    # Example SQLite databases (uncomment and modify as needed)
    # sqlite.databases = {
    #   "myapp" = "${home.homeDirectory}/databases/myapp.db";
    # };
  };

  # Enable global npm packages management
  programs.npmPackages = {
    enable = true;
    packages = [
      # MCP servers required by Claude
      "@upstash/context7-mcp"
      "mcp-sqlite"  # SQLite MCP server
      "@modelcontextprotocol/server-filesystem"
      # Claude Code CLI
      "@anthropic-ai/claude-code"
      # OpenAI Codex
      "@openai/codex"
      # Google Gemini CLI
      "@google/gemini-cli"
    ];
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
