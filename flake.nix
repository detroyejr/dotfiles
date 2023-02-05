{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # A default configuration that should work on non-NixOS machines.
      homeConfigurations.detroyejr = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./nix/home.nix
          ./nix/neovim.nix
          ./nix/python.nix
          ./nix/r.nix
          ./nix/rust.nix
          ./nix/git.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };

      homeConfigurations.surface = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./nix/home.nix
          ./nix/extras.nix
          ./nix/neovim.nix
          ./nix/python.nix
          ./nix/r.nix
          ./nix/rust.nix
          ./nix/git.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      
      nixosConfigurations.detroyejr = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/surface/configuration.nix ];
      };

      nixosConfigurations.proxmox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./nixos/proxmox/configuration.nix
        ];
      };
    };

}
