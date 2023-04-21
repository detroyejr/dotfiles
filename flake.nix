{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, devenv, hyprland, nix-colors, ... }:
    let
      # System
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Customization
      colorSchemeName = "tokyodark-terminal";
      colorScheme = nix-colors.colorSchemes.${colorSchemeName};
    in {
      # A default configuration that should work on non-NixOS machines.
      homeConfigurations.detroyejr = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./nix/home.nix
          ./nix/dev
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit devenv; };
      };

      nixosConfigurations.surface = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ./nixos/surface/configuration.nix
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit nix-colors colorSchemeName colorScheme hyprland devenv; };
            home-manager.users.detroyejr = {
              imports = [
                ./nix/home.nix
                ./nix/dev
                ./nix/window/hyprland
                ./nix/window/kitty.nix
                ./nix/apps/firefox.nix
                ./nix/apps/extras.nix
              ];
            };
          }
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
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit devenv; };
            home-manager.users.detroyejr = {
              imports = [
                ./nix/home.nix
                ./nix/dev/neovim.nix
                ./nix/dev/git.nix
                ./nix/dev/python.nix
               ];
            };
          }
        ];
      };

      nixosConfigurations.brick = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./nixos/brick/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit devenv; };
            home-manager.users.detroyejr = {
              imports = [
                ./nix/home.nix
                ./nix/dev
               ];
            };
          }
        ];
      };
    };
}
