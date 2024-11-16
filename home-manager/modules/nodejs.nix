{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs
    pnpm
 ];


 home.file = {
     ".npmrc".text = ''
     prefix=/Users/dan/.npm-global

     '';
 };
}
