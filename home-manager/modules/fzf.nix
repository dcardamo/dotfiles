{
  pkgs,
  lib,
  ...
}: let
  key-bindings = [
    # you can use the command `fish_key_reader` to get the key codes to use
    # {
    #   # ctrl+e
    #   lhs = "\\ce";
    #   rhs = "fzf-vim-widget";
    # }
    {
      # ctrl+g
      lhs = "\\a";
      rhs = "fzf-project-widget";
    }
    {
      # ctrl+t
      lhs = "\\ct";
      rhs = "fzf-file-widget-wrapped";
    }
    {
      # ctrl+r
      lhs = "\\cR";
      rhs = "fzf-history-widget-wrapped";
    }
  ];
in {
  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
    defaultOptions = [
      "--prompt='  '"
      "--marker=''"
      "--marker=' '"
      # this keybind should match the telescope ones in nvim config
      ''--bind="ctrl-d:preview-down,ctrl-f:preview-up"''
    ];
    fileWidgetCommand = "${pkgs.ripgrep}/bin/rg --files";
    fileWidgetOptions = [
      # Preview files with bat
      "--preview '${pkgs.bat}/bin/bat --color=always {}'"
      "--layout default"
    ];
  };
}
