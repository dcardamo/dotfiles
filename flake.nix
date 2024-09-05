{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # for nix-anywhere
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      #url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, home-manager, ... }@inputs: {
    # TODO: do I need these lines for formatter?
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    formmater.aarch64-darwin =
      nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

    # nixos systems:
    # See reference for nix-anywhere:
    # https://github.com/nix-community/nixos-anywhere-examples/blob/main/flake.nix
    nixosConfigurations = {
      # watercooled nvidia 3090
      pluto = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        specialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [
          disko.nixosModules.disko
          { disko.devices.disk.disk1.device = "/dev/nvme1n1"; }
          ./nixos/pluto/configuration.nix
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

      # OLD, not used
      #   beast = nixpkgs.lib.nixosSystem {
      #     specialArgs = {
      #       inherit inputs;
      #       vars = (import ./lib/vars.nix) { isDarwin = false; };
      #     }; # Pass flake inputs to our config
      #     system = "x86_64-linux";
      #     modules = [
      #       ./nixos/beast/configuration.nix
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useUserPackages = true;
      #         home-manager.users.dan = import ./home-manager/home.nix;
      #         home-manager.extraSpecialArgs = {
      #           inherit inputs;
      #           vars = (import ./lib/vars.nix) { isDarwin = false; };
      #         };
      #       }
      #     ];
      #   };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "dan@arcee.local" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./home-manager/home.nix ];
      };
      "mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) { isDarwin = true; };
        };
        modules = [ ./home-manager/home.nix ];
      };
      "linuxstandalone" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) {
            isDarwin = false;
            isLinux = true;
          };
        };
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
