{ isDarwin, ... }:
let
in {
  copyCmd = if isDarwin then "pbcopy" else "xclip -selection clipboard";
  pasteCmd = if isDarwin then "pbpaste" else "xlip -o -selection clipboard";

  authorizedSshKeys = [
    # dan ipad m4 pro:
    ''
      ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJ0uue7ICe3WJiXuKbFlsO9kZY+Az6TCDrn67Tl/KReHJPq4V86XdihWCG08IFUqSFzBqIC8zw6rmVJ+rduTYDU= dan@ipad
    ''
    # mac laptop mars
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe+4bVpPWZTF344M5TRzaz5/90s5finWdYFXhs+mwac dan@dans-mbp.lan"
    # dan iphone 15 pro
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEaCACN0Pby6uZWYBZ3umr8SCobH6OQgQ5gYs7IQUM55kiTY0A+l5HJ7FYKNUcYXq+HPbwkZ33ixjkfaZc99OTU= dan@iphone"
  ];
}
