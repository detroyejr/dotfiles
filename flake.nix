{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { nixpkgs, home-manager, hyprland, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Allow Unfreej
      nixpkgs.config.allowUnfree = true;

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
          ./nix/neovim.nix
          ./nix/python.nix
          ./nix/r.nix
          ./nix/rust.nix
          ./nix/git.nix
          ./nix/kitty.nix
          ./nix/hyprland.nix
          ./nix/dunst.nix
          ./nix/extras.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      
      nixosConfigurations.surface = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./nixos/surface/configuration.nix
          hyprland.nixosModules.default
          {
            programs.hyprland = {
              enable = true;
              xwayland = {
                enable = true;
                hidpi = true;
              };
              nvidiaPatches = false;
            };
          }
        ];
      };

      nixosConfigurations.proxmox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./nixos/proxmox/configuration.nix
        ];
      };
    };

}
