{ pkgs, lib, ... }:
{
  programs.git.enable = true;
  # direnv integration for flakes
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    gnumake
    direnv
    pgcli
    litecli
    jq
    sqlite
    git
    gh
    just

    # for compiling Treesitter parsers
    gcc

    # for Rust bindgen and other FFI tools
    libclang

    # formatters and linters
    alejandra
    shfmt
    cbfmt
    stylua
    codespell
    statix
    luajitPackages.luacheck
    shellcheck
    #prettierd
    nixpkgs-fmt
    nixfmt-classic

    # Go
    golangci-lint
    golangci-lint-langserver
    gopls
    gotools

    # Language servers
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server
    yaml-language-server
    (lib.lowPrio elixir-ls)
  ];
}
