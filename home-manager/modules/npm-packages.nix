{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.npmPackages;
in
{
  options.programs.npmPackages = {
    enable = mkEnableOption "Global npm packages management";

    packages = mkOption {
      type = types.listOf types.str;
      default = [ ];
      # ******* NOTE!!!!! this just examples, if you add here it doesn't actually add it! *****
      example = [
        "@upstash/context7-mcp"
        "@modelcontextprotocol/server-sqlite"
        "@modelcontextprotocol/server-filesystem"
        "typescript"
        "prettier"
        "@google/gemini-cli"
      ];
      description = "List of npm packages to install globally";
    };

    prefix = mkOption {
      type = types.str;
      default = "$HOME/.npm-global";
      description = "npm global prefix directory";
    };
  };

  config = mkIf cfg.enable {
    # Ensure nodejs is available
    home.packages = with pkgs; [
      nodejs
    ];

    # Set up npm configuration
    home.file.".npmrc".text = ''
      prefix=${cfg.prefix}
    '';

    # Install global npm packages
    home.activation.npmGlobalPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Ensure npm-global directory exists
      mkdir -p ${cfg.prefix}

      # Ensure npm is configured with the right prefix
      export npm_config_prefix="${cfg.prefix}"

      # Add npm-global/bin to PATH for this session
      export PATH="${cfg.prefix}/bin:$PATH"

      # Add Node.js from Nix to PATH
      export PATH="${pkgs.nodejs}/bin:$PATH"

      ensure_package() {
        local pkg="$1"
        echo "Ensuring npm package: $pkg"
        if ! ${pkgs.nodejs}/bin/npm install -g "$pkg"; then
          echo "Failed to install $pkg"
        fi
      }

      # Install packages
      ${concatMapStringsSep "\n" (pkg: ''
        ensure_package ${lib.escapeShellArg pkg}
      '') cfg.packages}

      echo "npm global packages installation complete"
    '';
  };
}
