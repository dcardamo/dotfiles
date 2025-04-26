{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
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
      mosh
      htop
      neofetch
      wget
      duf
      exiftool
      rsync
      tree
      pv

      # other utils and plugin dependencies
      fd
      catimg
      #luajitPackages.jsregexp #not sure what this is for.  comment out for now.
      fzf
      # pv # visualize pipe streams
      gnutar
      pigz
    ]
    ++ lib.lists.optionals isLinux []
    ++ lib.lists.optionals isDarwin [
      #exiftool
      #ffmpeg
      #imapsync
    ];
}
