{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_latest
    pnpm
 ];


 home.file = {
     ".npmrc".text = ''
     prefix=/Users/dan/.npm-global

     '';
 };
}
