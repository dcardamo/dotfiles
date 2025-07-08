{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.npmPackages;
in {
  options.programs.npmPackages = {
    enable = mkEnableOption "Global npm packages management";

    packages = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "@upstash/context7-mcp"
        "@modelcontextprotocol/server-sqlite"
        "@modelcontextprotocol/server-filesystem"
        "typescript"
        "prettier"
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
    home.activation.npmGlobalPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Ensure npm-global directory exists
      mkdir -p ${cfg.prefix}

      # Ensure npm is configured with the right prefix
      export npm_config_prefix="${cfg.prefix}"
      
      # Add npm-global/bin to PATH for this session
      export PATH="${cfg.prefix}/bin:$PATH"

      # Function to check if a package is installed
      is_installed() {
        npm list -g "$1" &>/dev/null
      }

      # Install packages
      ${concatMapStringsSep "\n" (pkg: ''
        if ! is_installed "${pkg}"; then
          echo "Installing npm package: ${pkg}"
          npm install -g "${pkg}" || echo "Failed to install ${pkg}"
        else
          echo "npm package already installed: ${pkg}"
        fi
      '') cfg.packages}

      echo "npm global packages installation complete"
    '';
  };
}