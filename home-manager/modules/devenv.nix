{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    #inputs.devenv.packages."${pkgs.system}".devenv
    #pkgs.cachix
    pkgs.devenv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
