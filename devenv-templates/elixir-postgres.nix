{
  pkgs,
  lib,
  ...
}: {
  dotenv.enable = true;
  difftastic.enable = true;

  packages =
    [
      pkgs.git
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk; [
      frameworks.Security
      frameworks.SystemConfiguration
      frameworks.CoreServices
      frameworks.CoreFoundation
    ]);

  languages = {
    elixir = {
      enable = true;
      package = pkgs.elixir;
    };
    javascript = {
      enable = true;
      pnpm = {
        enable = true;
        install.enable = true;
      };
    };
  };

  services.postgres = {
    enable = true;
    package = pkgs.postgresql_16;
    listen_addresses = "127.0.0.1";
    port = 5432;

    initialDatabases = [
      {
        name = "acme_dev";
        user = "postgres";
        pass = "postgres";
      }
      {
        name = "acme_test";
        user = "postgres";
        pass = "postgres";
      }
    ];
  };

  env = {
    DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/acme_dev";
  };

  enterShell = ''
    source ./.env
  '';
}
