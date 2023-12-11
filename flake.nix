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
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, hyprland, nix-colors, ... }:
    let
      # System
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      custom-colors = {
        nightfox = {
          colorSchemeName = "nightfox";
          wallpaper = "/home/detroyejr/.config/dotfiles/assets/wallpaper.jpg";
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
        };
        dayfox = {
          colorSchemeName = "dayfox";
          wallpaper = "/home/detroyejr/.config/dotfiles/assets/light-wallpaper.png";
          colorScheme = {
            author = "Jonathan De Troye";
            name = "Dayfox";
            slug = "dayfox";
            colors = {
              base00 = "f6f2ee";
              base01 = "dbd1dd";
              base02 = "d3c7bb";
              base03 = "534c45";
              base04 = "824d5b";
              base05 = "3d2b5a";
              base06 = "643f61";
              base07 = "f4ece6";
              base08 = "a5222f";
              base09 = "955f61";
              base0A = "ac5402";
              base0B = "396847";
              base0C = "287980";
              base0D = "2848a9";
              base0E = "6e33ce";
              base0F = "a440b5";
            };
          };
        };
      };

      # Customize colors with nix-colors or use a custom set.
      # colorSchemeName = "tokyodark-terminal";
      # colorScheme = nix-colors.colorSchemes.${colorSchemeName};

      colorSchemeName = "nightfox";
      colorScheme = custom-colors.${colorSchemeName}.colorScheme;
      wallpaper = custom-colors.${colorSchemeName}.wallpaper;

    in {
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

      nixosConfigurations.surface = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ./nixos/surface/configuration.nix
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager {
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
          home-manager.nixosModules.home-manager {
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
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
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
