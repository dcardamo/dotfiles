{ pkgs, lib, vars, ... }:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  home.packages = with pkgs;
    [
      ripgrep
      cargo
      jq
      mosh
    ]
    ++ lib.lists.optionals isLinux [  ]
    ++ lib.lists.optionals isDarwin [  ];
}
