{
  isDarwin,
  isLinux ? false,
  ...
}: {
  inherit isDarwin isLinux;
  copyCmd =
    if isDarwin
    then "pbcopy"
    else "xclip -selection clipboard";
  pasteCmd =
    if isDarwin
    then "pbpaste"
    else "xlip -o -selection clipboard";

  authorizedSshKeys = [
    # dan ipad m4 pro:
    ''
      ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJ0uue7ICe3WJiXuKbFlsO9kZY+Az6TCDrn67Tl/KReHJPq4V86XdihWCG08IFUqSFzBqIC8zw6rmVJ+rduTYDU= dan@ipad
    ''

    # mac laptop mars
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYFwcnSQIgkYPoNGF9aeLpXfChvD1TrE/vx4H5II2YI dan@hld.ca"

    # dan iphone 15 pro
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEaCACN0Pby6uZWYBZ3umr8SCobH6OQgQ5gYs7IQUM55kiTY0A+l5HJ7FYKNUcYXq+HPbwkZ33ixjkfaZc99OTU= dan@iphone"

    # dan ipad Mini
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJMhMLaN7oNq528VmycRtdj2y/iO5Ug1zo1YHH39upSSZ2TbJzqc7Aqf+5zCyO3z5udrEA8pOEovYYE3JMteaRE= dan@ipadmini"
  ];
}
