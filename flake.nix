{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      hyprland,
      nixos-cosmic,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          cudaSupport = false;
          input-fonts.acceptLicense = true;
        };
        overlays = [ (import ./overlays.nix) ];
      };

      nix-colors = import ./colors.nix;
      colorSchemeName = "rose-pine";
      colorScheme = nix-colors.${colorSchemeName}.colorScheme;
      wallpaper = nix-colors.${colorSchemeName}.wallpaper;
      rofi-background = nix-colors.${colorSchemeName}.rofi;

      default-home-configuration = {
        inherit pkgs;
        extraSpecialArgs = {
          nix-colors = nix-colors;
          colorSchemeName = colorSchemeName;
          colorScheme = colorScheme;
          wallpaper = wallpaper;
          hyprland = hyprland;
          rofi-background = rofi-background;
          isNvidia = false;
        };
        modules = [
          ./nix/home.nix
          ./nix/dev
          ./nix/window/hyprland
        ];
      };
      default-nixos-home-configuration = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = default-home-configuration.extraSpecialArgs;
        home-manager.users.detroyejr = {
          imports = default-home-configuration.modules;
        };
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      homeConfigurations.detroyejr = home-manager.lib.homeManagerConfiguration default-home-configuration;
      homeConfigurations.detroyejrNvidia =
        home-manager.lib.homeManagerConfiguration default-home-configuration
        // {
          extraSpecialArgs = default-home-configuration.extraSpecialArgs // {
            isNvidia = true;
          };
        };

      homeConfigurations.minimal = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit colorSchemeName colorScheme;
        };
        modules = [
          ./nix/home.nix
          ./nix/dev
        ];
      };

      nixosConfigurations = {
        "xps" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs outputs system;
            isNvidia = true;
            isFprint = true;
          };
          modules = [
            ./nixos/xps/configuration.nix
            nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
            home-manager.nixosModules.home-manager
            default-nixos-home-configuration
          ];
        };
        "mini" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs outputs system;
            isNvidia = false;
            isFprint = false;
          };
          modules = [
            ./nixos/mini/configuration.nix
            # Running the 3070, but I think this is close enough.
            nixos-hardware.nixosModules.dell-optiplex-3050
            home-manager.nixosModules.home-manager
            default-nixos-home-configuration
          ];
        };
        "tower" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs outputs system;
            isNvidia = false;
            isFprint = false;
          };
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
        "brick" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs outputs system;
            isNvidia = true;
            isFprint = false;
          };
          modules = [
            ./nixos/brick/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit
                  nix-colors
                  colorSchemeName
                  colorScheme
                  wallpaper
                  rofi-background
                  ;
                isNvidia = true;
              };
              home-manager.users.detroyejr = {
                imports = [
                  ./nix/home.nix
                  ./nix/dev
                ];
              };
            }
          ];
        };
        "potato" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs outputs system;
            isNvidia = false;
            isFprint = false;
          };
          modules = [
            ./nixos/potato/configuration.nix
            nixos-cosmic.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit
                  nix-colors
                  colorSchemeName
                  colorScheme
                  ;
              };
              home-manager.users.detroyejr = {
                imports = [
                  ./nix/home.nix
                  ./nix/dev
                  ./nix/window/hyprland/wezterm.nix
                  ./nix/window/hyprland/kitty.nix
                ];
              };
            }
          ];
        };
      };
      colmena = {
        meta.nixpkgs = pkgs;
        mini-2 = import ./nixos/minis/mini-2.nix;
        mini-3 = import ./nixos/minis/mini-3.nix;
        mini-4 = import ./nixos/minis/mini-4.nix;
        mini-5 = import ./nixos/minis/mini-5.nix;
      };
    };
}
