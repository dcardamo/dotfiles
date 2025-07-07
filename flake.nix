{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      #url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # GMKtec EVO-X2 with AMD Ryzen AI Max 395
      neptune = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [
          ./nixos/neptune/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              vars = (import ./lib/vars.nix) {
                isDarwin = false;
                isLinux = true;
              };
            };
          }
        ];
      };

      # Home docker server
      arcee = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # old way
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [
          ./nixos/arcee/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              vars = (import ./lib/vars.nix) {
                isDarwin = false;
                isLinux = true;
              };
            };
          }
        ];
      };

      # cottage docker server
      heatwave = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # old way
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [
          ./nixos/heatwave/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              vars = (import ./lib/vars.nix) {
                isDarwin = false;
                isLinux = true;
              };
            };
          }
        ];
      };

      # Development container configuration
      devcontainer = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux"; # For Apple Silicon Macs
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [
          ./nixos/devcontainer/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              vars = (import ./lib/vars.nix) {
                isDarwin = false;
                isLinux = true;
              };
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {isDarwin = true;};
        };
        modules = [./home-manager/home.nix];
      };
      "linux-aarch64" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [./home-manager/home.nix];
      };
      "container-aarch64" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [./home-manager/home.nix];
      };
      "container-x86_64" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [./home-manager/home.nix];
      };
    };
  };
}
