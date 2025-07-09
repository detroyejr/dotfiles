{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      hyprland,
      jovian,
      sops-nix,
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
        overlays = [ (import ./nixos/overlays.nix) ];
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      nixosConfigurations = {
        "xps" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
            isNvidia = true;
          };
          modules = [
            ./nixos/xps/configuration.nix
            nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
            sops-nix.nixosModules.sops
          ];
        };
        "mini" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
            isNvidia = false;
          };
          modules = [
            ./nixos/mini/configuration.nix
            # Running the 3070, but I think this is close enough.
            nixos-hardware.nixosModules.dell-optiplex-3050
            sops-nix.nixosModules.sops
          ];
        };
        "skate" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
            isNvidia = false;
          };
          modules = [
            ./nixos/skate/configuration.nix
            jovian.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        "tower" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
            isNvidia = false;
          };
          modules = [
            ./nixos/tower/configuration.nix
          ];
        };
        "brick" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
            isNvidia = true;
          };
          modules = [
            ./nixos/brick/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
          ];
        };
        "potato" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
            isNvidia = false;
          };
          modules = [
            ./nixos/potato/configuration.nix
            sops-nix.nixosModules.sops
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
