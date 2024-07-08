{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    hyprland,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
    };

    nix-colors = import ./colors.nix;
    colorSchemeName = "rose-pine";
    colorScheme = nix-colors.${colorSchemeName}.colorScheme;
    wallpaper = nix-colors.${colorSchemeName}.wallpaper;

    default-home-configuration = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit nix-colors colorSchemeName colorScheme wallpaper hyprland;};
      home-manager.users.detroyejr = {
        imports = [
          ./nix/home.nix
          ./nix/dev
          ./nix/window/hyprland
        ];
      };
    };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    # A default configuration that should work on non-NixOS machines.
    homeConfigurations.detroyejr = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {inherit colorSchemeName colorScheme;};
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
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
          default-home-configuration
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
          default-home-configuration
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
            home-manager.extraSpecialArgs = {inherit nix-colors colorSchemeName colorScheme wallpaper;};
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
  };
}
