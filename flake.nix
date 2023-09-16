{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # darwin = {
    #   url = "github:LnL7/nix-darwin/master";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixvim = {
      #url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      url = "github:nix-community/nixvim/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      your-hostname = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) { isDarwin = false; };
        }; # Pass flake inputs to our config
        system = "x86_64-linux";
        # > Our main nixos configuration file <
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              vars = (import ./lib/vars.nix) { isDarwin = false; };
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "dan@arcee.local" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
          vars = (import ./lib/vars.nix) { isDarwin = false; };
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
        modules = [
          ./home-manager/home.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };
    };
  };
}
