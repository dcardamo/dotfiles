{ pkgs, lib, vars, ... }:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  xdg.configFile = {
    "codespell/custom_dict.txt".text = ''
      crate
      Crate
    '';
    "cbfmt.toml".text = ''
      [languages]
      rust = ["${pkgs.rustfmt}/bin/rustfmt"]
      go = ["${pkgs.go}/bin/gofmt"]
      lua = ["${pkgs.stylua}/bin/stylua --config-path ${
        ../../conf/stylua.toml
      } -s -"]
      nix = ["${pkgs.nixfmt}/bin/nixfmt"]
    '';
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
      ripgrep
      mosh
      htop
      neofetch
      wget

      # other utils and plugin dependencies
      fd
      catimg
      #luajitPackages.jsregexp #not sure what this is for.  comment out for now.
      fzf
      # pv # visualize pipe streams
      gnutar
    ] ++ lib.lists.optionals isLinux [ ] ++ lib.lists.optionals isDarwin [
      #exiftool
      #ffmpeg
      #imapsync 
    ];
}
