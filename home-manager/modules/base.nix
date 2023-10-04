{
  pkgs,
  lib,
  vars,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  xdg.configFile = {
    "codespell/custom_dict.txt".text = ''
      crate
      Crate
    '';
    "cbfmt.toml".text = ''
      [languages]
      rust = ["${pkgs.rustfmt}/bin/rustfmt"]
      go = ["${pkgs.go}/bin/gofmt"]
      lua = ["${pkgs.stylua}/bin/stylua --config-path ${../../conf/stylua.toml} -s -"]
      nix = ["${pkgs.nixfmt}/bin/nixfmt"]
    '';
    "ripgrep_ignore".text = ''
      .git/
      yarn.lock
      package-lock.json
      packer_compiled.lua
      .DS_Store
      .netrwhist
      dist/
      node_modules/
      **/node_modules/
      wget-log
      wget-log.*
      /vendor
    '';
  };

  home.packages = with pkgs;
    [
      ripgrep
      cargo
      jq
      mosh
      zellij
      gnumake
      direnv
      htop
      neofetch

      # for compiling Treesitter parsers
      gcc

      # formatters and linters
      nixfmt
      alejandra
      rustfmt
      shfmt
      cbfmt
      stylua
      codespell
      statix
      luajitPackages.luacheck
      #prettierd

      # LSP servers
      efm-langserver
      nil
      rust-analyzer
      taplo
      gopls
      lua
      shellcheck
      marksman
      sumneko-lua-language-server
      nodePackages_latest.typescript-language-server

      # this includes css-lsp, html-lsp, json-lsp, eslint-lsp
      nodePackages_latest.vscode-langservers-extracted

      # other utils and plugin dependencies
      fd
      catimg
      sqlite
      lemmy-help
      luajitPackages.jsregexp
      fzf
      cargo
      cargo-nextest
      clippy
      glow
    ]
    ++ lib.lists.optionals isLinux []
    ++ lib.lists.optionals isDarwin [];

  programs.gh.enable = true;
}
