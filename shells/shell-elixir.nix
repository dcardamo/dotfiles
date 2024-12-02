# run with `nix-shell shell-elixir.nix`
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "elixir-env-shell";
  buildInputs = with pkgs; [
    elixir_1_16
  ];
}
