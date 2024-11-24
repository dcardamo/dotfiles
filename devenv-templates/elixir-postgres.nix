{
  pkgs,
  ...
}: {
  dotenv.enable = true;
  difftastic.enable = true;

  packages = [
    pkgs.git
  ];

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
        name = "mydb";
        user = "myuser";
        pass = "mypass";
      }
    ];
  };

  env = {
    DATABASE_URL = "postgresql://myuser:mypass@localhost:5432/mydb";
  };

  enterShell = ''
    source ./.env
  '';
}
