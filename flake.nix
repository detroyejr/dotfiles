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

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      sops-nix,
      disko,
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
        overlays = map import (getFiles ./packages);
      };

      getFiles =
        dir: builtins.attrValues (builtins.mapAttrs (file: _: "${dir}/${file}") (builtins.readDir dir));

      mkSystem =
        name: mods:
        let
          inherit (pkgs.lib) optional lists;
          hostFiles =
            if (builtins.pathExists (./. + "/hosts/${name}")) then getFiles (./hosts + "/${name}") else null;
          modules = lists.flatten [
            ./modules
            mods
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            (optional (!isNull hostFiles) hostFiles)
          ];
        in
        inputs.nixpkgs.lib.nixosSystem {
          inherit system pkgs modules;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
          };
        };
      getProgram =
        name: (mkSystem "default" { programs.${name}.enable = true; }).config.programs.${name}.finalPackage;

      neovim = getProgram "neovim";
      firefox = getProgram "firefox";
      hosts = [
        "longsword"
        "mongoose"
        "odp-1"
        "pelican"
        "sabre"
        "scorpion"
      ];
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      packages.${system} = {
        inherit neovim firefox;
        default = pkgs.buildEnv {
          pname = "dots";
          version = "0.1";
          paths = [
            firefox
            neovim
            pkgs.bc
            pkgs.gh
            pkgs.just
            pkgs.nixd
            pkgs.nixfmt
            pkgs.rclone
          ];
        };
      };

      nixosConfigurations =
        builtins.listToAttrs (
          map (name: {
            name = name;
            value = mkSystem name { };
          }) hosts
        )
        // {
          iso = mkSystem "iso" {
            networking.networkmanager.enable = true;
            programs = {
              firefox.enable = true;
              git.enable = true;
              hyprland.enable = true;
              wezterm.enable = true;
              zsh.enable = true;
            };
            environment.systemPackages = [ pkgs.neovim ];
          };

          "razorback" = nixpkgs.lib.nixosSystem {
            pkgs = import nixpkgs {
              system = "aarch64-linux";
              config = {
                allowUnfree = true;
                allowBroken = true;
                cudaSupport = false;
                input-fonts.acceptLicense = true;
              };
            };

            system = "aarch64-linux";
            specialArgs = {
              inherit
                inputs
                outputs
                system
                ;
            };
            modules = [
              ./hosts/razorback/configuration.nix
              ./hosts/razorback/hardware-configuration.nix
              ./modules
              nixos-hardware.nixosModules.raspberry-pi-4
              sops-nix.nixosModules.sops
            ];
          };
        };

      colmena = {
        meta.nixpkgs = pkgs;
        defaults = {
          imports = [
            sops-nix.nixosModules.sops
          ];
        };
        odp-2 = import ./hosts/odp/odp-2.nix;
        odp-3 = import ./hosts/odp/odp-3.nix;
        odp-4 = import ./hosts/odp/odp-4.nix;
        odp-5 = import ./hosts/odp/odp-5.nix;
      };
    };
}
