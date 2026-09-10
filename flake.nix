{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
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

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omarchy-quickshell = {
      url = "github:detroyejr/omarchy-quickshell-nix";
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
      omarchy-quickshell,
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
        system: name: mods:
        let
          inherit (pkgs.lib) optional lists;
          hostFiles =
            if (builtins.pathExists (./. + "/hosts/${name}")) then getFiles (./hosts + "/${name}") else null;
          modules = lists.flatten [
            ./modules
            mods
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            omarchy-quickshell.nixosModules.omarchy-quickshell
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
        name:
        (mkSystem "linux_x86-64" "default" { programs.${name}.enable = true; })
        .config.programs.${name}.finalPackage;

      neovim = getProgram "neovim";
      firefox = getProgram "firefox";
      hosts = [
        "longsword"
        "mongoose"
        "odp-1"
        "odp-2"
        "odp-3"
        "odp-4"
        "odp-5"
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
            pkgs.clang-tools
            pkgs.gh
            pkgs.just
            pkgs.lua-language-server
            pkgs.nixd
            pkgs.nixfmt
            pkgs.rclone
            pkgs.ripgrep
            pkgs.tree-sitter
          ];
        };
      };

      nixosConfigurations =
        builtins.listToAttrs (
          map (name: {
            name = name;
            value = mkSystem "linux_x86-64" name { };
          }) hosts
        )
        // {
          razorback = mkSystem "aarch64-linux" "razorback" { };
          iso = mkSystem "linux_x86-64" "iso" {
            imports = [ "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" ];
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
        };
    };
}
