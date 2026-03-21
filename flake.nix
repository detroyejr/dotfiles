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
      jovian,
      sops-nix,
      disko,
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

      packages.x86_64-linux.default =
        let
          lib = pkgs.lib;
          config =
            (import <nixpkgs/nixos/lib/eval-config.nix> {
              modules = [
                ./modules/dev/neovim.nix
                ./modules/dev/zsh.nix
                ./modules/apps/firefox.nix
                { programs.neovim.enable = true; }
              ];
            }).config;
          nvimRuntime = pkgs.vimUtils.buildVimPlugin {
            pname = "neovim-runtime";
            version = "0.1.0";
            src = pkgs.linkFarm "nvim-runtime" [
              {
                name = "lsp";
                path = ./dotfiles/nvim/lsp;
              }
              {
                name = "snippets";
                path = ./dotfiles/nvim/snippets;
              }
            ];
          };
          neovim = pkgs.neovim.override {
            configure = config.programs.neovim.configure // {
              packages.myVimPackage.start =
                (config.programs.neovim.configure.packages.myVimPackage.start or [ ])
                ++ [ nvimRuntime ];
            };
          };
        in
        pkgs.buildEnv {
          pname = "dots";
          version = "0.1";
          paths = [
            (pkgs.wrapFirefox pkgs.firefox-unwrapped {
              extraPrefs = lib.concatLines (
                lib.mapAttrsToList (
                  name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
                ) config.programs.firefox.preferences
              );
              extraPolicies = config.programs.firefox.policies;
            })
            neovim
            pkgs.just
            pkgs.nixd
          ];
        };

      nixosConfigurations = {
        "iso" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
          };
          modules = [
            ./module
            sops-nix.nixosModules.sops
            {
              networking.networkmanager.enable = true;
              programs = {
                firefox.enable = true;
                git.enable = true;
                hyprland.enable = true;
                wezterm.enable = true;
                zsh.enable = true;
              };
              environment.systemPackages = with pkgs; [ neovim ];
            }
          ];
        };
        "longsword" = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit
              inputs
              outputs
              system
              ;
          };
          modules = [
            ./hosts/longsword/configuration.nix
            ./hosts/longsword/hardware-configuration.nix
            ./modules
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
          };
          modules = [
            ./hosts/odp-1/configuration.nix
            ./hosts/odp-1/hardware-configuration.nix
            ./modules

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
          };
          modules = [
            ./hosts/mongoose/configuration.nix
            ./hosts/mongoose/hardware-configuration.nix
            ./modules
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
          };
          modules = [
            ./hosts/scorpion/configuration.nix
            ./hosts/scorpion/hardware-configuration.nix
            ./modules
            nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
            sops-nix.nixosModules.sops
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
          };
          modules = [
            ./hosts/pelican/configuration.nix
            ./modules
            disko.nixosModules.disko
            nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano
            sops-nix.nixosModules.sops
          ];
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
            overlays = map import packages;
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
