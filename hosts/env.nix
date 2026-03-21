{ pkgs, ... }:
let
  lib = pkgs.lib;
  config =
    (import <nixpkgs/nixos/lib/eval-config.nix> {
      modules = [
        ../modules/dev/neovim.nix
        ../modules/dev/zsh.nix
        ../modules/apps/firefox.nix
        { 
          programs.firefox.enable = true;
          programs.neovim.enable = true; 
        }
      ];
    }).config;
  nvimRuntime = pkgs.vimUtils.buildVimPlugin {
    pname = "neovim-runtime";
    version = "0.1.0";
    src = pkgs.linkFarm "nvim-runtime" [
      {
        name = "lsp";
        path = ../dotfiles/nvim/lsp;
      }
      {
        name = "snippets";
        path = ../dotfiles/nvim/snippets;
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
  firefox = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPrefs = lib.concatLines (
      lib.mapAttrsToList (
        name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
      ) config.programs.firefox.preferences
    );
    extraPolicies = config.programs.firefox.policies;
  };
in
pkgs.buildEnv {
  pname = "dots";
  version = "0.1";
  paths = [
    firefox
    neovim
    pkgs.just
    pkgs.nixd
    pkgs.nixfmt
  ];
}
