{pkgs, ...}: {
  home.packages = with pkgs; [
    biome
    #helix-gpt # has a conflict with prettier Jun 5 2025
    marksman
    nil
    taplo
    # terraform-ls
    vscode-langservers-extracted

    evil-helix
  ];

  xdg.configFile = {
    "helix/languages.toml".source = ./languages.toml;
    "helix/config.toml".source = ./config.toml;
  };
}
