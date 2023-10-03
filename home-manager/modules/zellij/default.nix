{
  pkgs,
  lib,
  vars,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  # xdg.configFile = {
  #   "zellij" = {
  #     source = ./conf;
  #     recursive = true;
  #   };
  # };
}
