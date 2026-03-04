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
    rev = "995b75fd5129726c2ac922227944ab51871b05a5";
    hash = "sha256-ZpEsy5/lVrLd5iiaxhGT5XBRIizQt1hPk+e5qFk3uL4=";
  };
  opencodeNvim = pkgs.fetchFromGitHub {
    owner = "NickvanDyke";
    repo = "opencode.nvim";
    tag = "v0.5.0";
    hash = "sha256-4rdqglvsnf7BWd5eXHL+/KGV92puz1ZDmeCdFuR+Qjs=";
  };
  snacks = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "snacks.nvim";
    rev = "9912042fc8bca2209105526ac7534e9a0c2071b2";
    hash = "sha256-987hqjUll8ICGC6NRP2AKGNVpZODejyiwcVAecdKGl8=";
  };
in
{
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  environment.systemPackages = [
    pkgs.tree-sitter
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
