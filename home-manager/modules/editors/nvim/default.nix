{ config, pkgs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
in {
  home.sessionVariables = {
    MANPAGER = "nvim -c 'Man!' -o -";
  };

  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins.lightline.enable = true;
  };

}
