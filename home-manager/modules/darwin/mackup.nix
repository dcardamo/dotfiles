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
  home.file.".mackup.cfg".text = ''
    [storage]
    engine = icloud

    [applications_to_sync]
    raycast
    hazel
    stats
    lightroom
  '';
}
