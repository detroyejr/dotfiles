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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, hyprland, ... }:
    let
      # System
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nix-colors = import ./colors.nix;
      colorSchemeName = "nightfox-custom";
      colorScheme = nix-colors.${colorSchemeName}.colorScheme;
      wallpaper = nix-colors.${colorSchemeName}.wallpaper;

    in
    {
      # A default configuration that should work on non-NixOS machines.
      homeConfigurations.detroyejr = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;


        extraSpecialArgs = { inherit colorSchemeName; };
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./nix/home.nix
          ./nix/dev
        ];
      };
      
      nixosConfigurations.xps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.dell-xps-15-9520
          nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
          ./nixos/xps/configuration.nix
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit nix-colors colorSchemeName colorScheme wallpaper hyprland; };
            home-manager.users.detroyejr = {
              imports = [
                ./nix/home.nix
                ./nix/dev
                ./nix/window/hyprland
              ];
            };
          }
        ];
      };

      nixosConfigurations.surface = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ./nixos/surface/configuration.nix
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit nix-colors colorSchemeName colorScheme wallpaper hyprland; };
            home-manager.users.detroyejr = {
              imports = [
                ./nix/home.nix
                ./nix/dev
                ./nix/window/hyprland
              ];
            };
          }
        ];
      };

      nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/tower/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
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
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit nix-colors colorSchemeName colorScheme wallpaper; };
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
