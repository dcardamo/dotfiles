{pkgs, ...}: {
  programs.git.enable = true;
  # direnv integration for flakes
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    gnumake
    direnv
    pgcli
    jq
    sqlite
    git
    gitui

    # Rust
    cargo
    clang-tools
    rust-analyzer

    # for compiling Treesitter parsers
    gcc

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

    # Python
    pgformatter
    (python3.withPackages
      (p: (with p; [black isort python-lsp-black python-lsp-server])))

    # Language servers
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server-nodejs
    yaml-language-server
    elixir-ls
  ];
}
