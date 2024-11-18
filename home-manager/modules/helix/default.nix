{pkgs, ...}: {
  home.packages = with pkgs; [
    biome
    helix-gpt
    marksman
    nil
    taplo
    taplo-lsp
    # terraform-ls
    vscode-langservers-extracted

    evil-helix
  ];

  xdg.configFile = {
    "helix/languages.toml".source = ./languages.toml;
    "helix/config.toml".source = ./config.toml;
  };
}
