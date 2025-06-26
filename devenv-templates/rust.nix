{
  pkgs,
  lib,
  ...
}: {
  dotenv.enable = true;
  dotenv.filename = ".env";

  difftastic.enable = true;

  languages.rust = {
    enable = true;
    # https://devenv.sh/reference/options/#languagesrustchannel
    channel = "stable";

    components = ["rustc" "cargo" "clippy" "rustfmt" "rust-analyzer"];
  };

  git-hooks.hooks = {
    shellcheck.enable = true;
    rustfmt.enable = true;
    clippy.enable = true;
    clippy.packageOverrides.cargo = pkgs.cargo;
    clippy.packageOverrides.clippy = pkgs.clippy;
    # some hooks provide settings
    clippy.settings.allFeatures = true;
  };

  packages =
    [
      pkgs.sqlx-cli
      pkgs.bacon
      pkgs.cargo-nextest
      pkgs.cargo-update
      pkgs.watchexec
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk; [
      frameworks.Security
      frameworks.SystemConfiguration
      frameworks.CoreServices
      frameworks.CoreFoundation
      pkgs.libiconv # for ollama-rs
    ]);

  env = {
    #RUST_BACKTRACE="full";
  };

  enterShell = ''
    source ./.env
  '';
}
