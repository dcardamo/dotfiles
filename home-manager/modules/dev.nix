{pkgs, ...}: {
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
  ];
}
