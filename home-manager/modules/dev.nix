{ pkgs, ... }: {
  home.packages = with pkgs; [
    gnumake
    direnv
    pgcli
    jq
    sqlite
    git
    glow # git client

    # Rust
    cargo

    # for compiling Treesitter parsers
    gcc

    # formatters and linters
    nixfmt
    alejandra
    shfmt
    cbfmt
    stylua
    codespell
    statix
    luajitPackages.luacheck
    #prettierd

    # LSP servers
    nil
    taplo
    lua
    shellcheck
  ];
}
