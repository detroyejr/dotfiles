{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
      nixos-hardware,
      jovian,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      dir = packages/.;
      packages = builtins.attrValues (
        builtins.mapAttrs (file: _: "${dir}/${file}") (builtins.readDir dir)
      );
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          cudaSupport = false;
          input-fonts.acceptLicense = true;
        };
        overlays = map import packages;
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      nixosConfigurations = {
        "longsword" = nixpkgs.lib.nixosSystem {
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
            ./nixos/hosts/longsword/configuration.nix
            nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
            sops-nix.nixosModules.sops
          ];
        };
        "odp-1" = nixpkgs.lib.nixosSystem {
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
            ./nixos/hosts/odp-1/configuration.nix

            # Running the 3070, but I think this is close enough.
            nixos-hardware.nixosModules.dell-optiplex-3050
            sops-nix.nixosModules.sops
          ];
        };
        "mongoose" = nixpkgs.lib.nixosSystem {
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
            ./nixos/hosts/mongoose/configuration.nix
            jovian.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        "scorpion" = nixpkgs.lib.nixosSystem {
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
            ./nixos/hosts/scorpion/configuration.nix
            nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
          ];
        };
        "pelican" = nixpkgs.lib.nixosSystem {
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
            ./nixos/hosts/pelican/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
      };
      colmena = {
        meta.nixpkgs = pkgs;
        odp-2 = import ./nixos/hosts/odp/odp-2.nix;
        odp-3 = import ./nixos/hosts/odp/odp-3.nix;
        odp-4 = import ./nixos/hosts/odp/odp-4.nix;
        odp-5 = import ./nixos/hosts/odp/odp-5.nix;
      };
    };
}
