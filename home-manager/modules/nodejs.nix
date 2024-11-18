{pkgs, ...}: {
  home.packages = with pkgs; [
    # nodejs_latest
    nodejs
    pnpm

    nodePackages.prettier
    nodePackages.typescript-language-server

    typescript
 ];


 home.file = {
     ".npmrc".text = ''
     prefix=/Users/dan/.npm-global

     '';
 };
}
