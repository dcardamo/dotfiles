{pkgs, ...}: {
    home.packages = with pkgs; [
        nixd # nix language server
        ruff # python linter
        solargraph #ruby language server

        (python3.withPackages
          (p: (with p; [black isort python-lsp-black python-lsp-server])))
    ];

    # These are commented out for now since the config is changing quickly
    # and its easier to just let zed make its own changes for now.
    # TODO: move config here in the future
    # xdg.configFile."zed/settings.json".source = ./settings.json;
    # xdg.configFile."zed/keymap.json".source = ./keymap.json;
}
