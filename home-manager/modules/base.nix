{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
  
  # Control browsh installation - disabled by default
  # Set to true to enable browsh and firefox
  enableBrowsh = false;
in {
  xdg.configFile = {
    "ripgrep_ignore".text = ''
      .git/
      yarn.lock
      package-lock.json
      packer_compiled.lua
      .DS_Store
      .netrwhist
      dist/
      node_modules/
      **/node_modules/
      wget-log
      wget-log.*
      /vendor
    '';
  };

  home.packages = with pkgs;
    [
      bash
      mosh
      htop
      neofetch
      wget
      duf
      exiftool
      rsync
      tree
      lsd
      pv

      # other utils and plugin dependencies
      fd
      #catimg -- failing build
      #luajitPackages.jsregexp #not sure what this is for.  comment out for now.
      fzf
      # pv # visualize pipe streams
      gnutar
      pigz
      pwgen
      skim
      unzip
    ]
    ++ lib.lists.optionals (isLinux && enableBrowsh) [
      browsh # Text-based web browser with Firefox rendering
      firefox # Required dependency for browsh
    ]
    ++ lib.lists.optionals isDarwin [
      #exiftool
      #ffmpeg
      #imapsync
    ];
}
