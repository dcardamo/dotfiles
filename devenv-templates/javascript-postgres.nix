{pkgs, ...}: {
  dotenv.enable = true;
  dotenv.filename = ".env";

  difftastic.enable = true;

  packages = [
    pkgs.git
    #pkgs.watchexec
  ];

  languages.javascript = {
    enable = true;
    pnpm = {
      enable = true;
      install.enable = true;
    };
  };

  pre-commit.hooks = {
    #shellcheck.enable = true;
    eslint.enable = true;
    prettier.enable = true;
  };

  services.postgres = {
    enable = true;
    package = pkgs.postgresql_16;
    listen_addresses = "127.0.0.1";
    port = 5432;

    initialDatabases = [
      {
        name = "purpose_dev";
        user = "purpose";
        pass = "purposepass";
      }
    ];
  };

  env = {
    DATABASE_URL = "postgresql://purpose:purposepass@localhost:5432/purpose_dev";
  };

  enterShell = ''
    source ./.env
  '';
}
