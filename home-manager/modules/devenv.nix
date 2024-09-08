{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [pkgs.cachix pkgs.devenv];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
