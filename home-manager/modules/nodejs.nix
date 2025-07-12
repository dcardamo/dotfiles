{pkgs, ...}: {
  home.packages = with pkgs; [
    # nodejs_latest
    nodejs
    pnpm

    nodePackages.prettier
    nodePackages.typescript-language-server

    typescript
  ];
}
