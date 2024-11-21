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

  pre-commit.hooks = {
    rustfmt.enable = true;
    clippy.enable = true;
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

  services.postgres = {
    enable = true;
    package = pkgs.postgresql_16;
    listen_addresses = "127.0.0.1";
    port = 9433;

    extensions = extensions: [
      extensions.pgvector
    ];

    initialScript = ''
      CREATE USER diwdev WITH PASSWORD 'diwdev' SUPERUSER;
    '';

    initialDatabases = [
      {
        name = "indexer_dev";
        # user = "diwdev";
        # pass = "diwdev";
      }
    ];
  };

  env = {
    DATABASE_URL = "postgresql://diwdev:diwdev@localhost:9433/indexer_dev";
    # RUST_BACKTRACE="full";
  };

  enterShell = ''
    source ./.env
  '';
}
