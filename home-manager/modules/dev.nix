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
    efm-langserver
    nil
    taplo
    lua
    shellcheck
    marksman
    sumneko-lua-language-server
    (python3.withPackages (ps:
      with ps;
      [
        python-lsp-server
        python-lsp-black
        black
        isort
        jedi
        pyflakes
        pylint
        pyls-isort
      ] ++ python-lsp-server.optional-dependencies.all))
  ];
}
