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

      # Customize colors with nix-colors or use a custom set.
      # colorSchemeName = "tokyodark-terminal";
      # colorScheme = nix-colors.colorSchemes.${colorSchemeName};

      colorSchemeName = "nightfox";
      colorScheme = {
        author = "Jonathan De Troye";
        name = "Nightfox";
        slug = "nightfox";
        colors = { 
          base00 = "192330";
          base01 = "212e3f";
          base02 = "29394f";
          base03 = "575860";
          base04 = "71839b";
          base05 = "cdcecf";
          base06 = "aeafb0";
          base07 = "e4e4e5";
          base08 = "c94f6d";
          base09 = "f4a261";
          base0A = "dbc074";
          base0B = "81b29a";
          base0C = "63cdcf";
          base0D = "719cd6";
          base0E = "9d79d6";
          base0F = "d67ad2";
        };
      };
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
                ./nix/dev/git.nix
                ./nix/dev/kitty.nix
                ./nix/dev/neovim.nix
                ./nix/dev/python.nix
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
              };
              enableNvidiaPatches = false;
            };
          }
        ];
      };

      nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/tower/configuration.nix
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
