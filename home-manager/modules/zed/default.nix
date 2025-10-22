{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd # nix language server
    # solargraph #ruby language server -- failing to build
    bash-language-server
    shellcheck
  ];

  # These are commented out for now since the config is changing quickly
  # and its easier to just let zed make its own changes for now.
  # TODO: move config here in the future
  # xdg.configFile."zed/settings.json".source = ./settings.json;
  # xdg.configFile."zed/keymap.json".source = ./keymap.json;
}
