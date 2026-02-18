{ pkgs, ... }:
let
  neovimConfig = pkgs.stdenv.mkDerivation {
    pname = "neovim-config";
    version = "1.0";
    src = ../../dotfiles/nvim;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out && cp -r . $out
    '';
  };
  nvim-treesitter = pkgs.fetchFromGitHub {
    owner = "nvim-treesitter";
    repo = "nvim-treesitter";
    rev = "2bd9b9b4f12eed175fba35ca2db8e8584546a4ec";
    hash = "sha256-riJj1ol45LhgDP0BxboNyG3ed/dT6KgmdYK6rzyFsAw=";
  };
  opencodeNvim = pkgs.fetchFromGitHub {
    owner = "NickvanDyke";
    repo = "opencode.nvim";
    tag = "v0.3.0";
    hash = "sha256-fYXMLg702MAGpfoIYmFDQ5TkC+EWtuv0r3t0supsV7E=";
  };
  snacks = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "snacks.nvim";
    tag = "v2.30.0";
    hash = "sha256-5m65Gvc6DTE9v7noOfm0+iQjDrqnrXYYV9QPnmr1JGY=";
  };
in
{
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  environment.systemPackages = [
    pkgs.tree-sitter
    pkgs.copilot-language-server
  ];
  environment.etc = {
    "xdg/nvim".source = neovimConfig;
  };

  system.activationScripts = {
    nvimPlugins = {
      deps = [ "specialfs" ];
      text = ''
        export DIR=/home/detroyejr/.local/share
        mkdir -p ''${DIR}/nvim/site/pack/plugins/start/nvim-treesitter \
          ''${DIR}/nvim/site/queries \
          ''${DIR}/nvim/site/parser
        ln -sfn ${nvim-treesitter}/* ''${DIR}/nvim/site/pack/plugins/start/nvim-treesitter

        mkdir -p ''${DIR}/nvim/site/pack/plugins/start/opencode
        ln -sfn ${opencodeNvim}/* ''${DIR}/nvim/site/pack/plugins/start/opencode

        mkdir -p ''${DIR}/nvim/site/pack/plugins/start/snacks
        ln -sfn ${snacks}/* ''${DIR}/nvim/site/pack/plugins/start/snacks
      '';
    };
  };
}
