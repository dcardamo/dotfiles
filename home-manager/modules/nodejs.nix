{pkgs, ...}: {
  home.packages = with pkgs; [
    # nodejs_latest
    nodejs
    pnpm

    nodePackages.prettier
    nodePackages.typescript-language-server

    typescript
  ];

  # npmrc is now managed by npm-packages.nix module
  # home.file = {
  #   ".npmrc".text = ''
  #     prefix=/Users/dan/.npm-global
  #
  #   '';
  # };
}
