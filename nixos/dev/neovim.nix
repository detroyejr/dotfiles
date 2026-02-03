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
    rev = "4fc09bee78e91bf4ba471cdab4bf9dfa37fde51c";
    hash = "sha256-PBiYshT9p5l4YZHv8DHvcB396mKwRIfa8F2y0VgUuI4=";
  };
  opencodeNvim = pkgs.fetchFromGitHub {
    owner = "NickvanDyke";
    repo = "opencode.nvim";
    tag = "v0.1.0";
    hash = "sha256-awG2mJYGQEf7U3+UsCB5X1Hb5eCgD8x2DojiDiXrHpw=";
  };
  snacks = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "snacks.nvim";
    rev = "fe7cfe9800a182274d0f868a74b7263b8c0c020b";
    hash = "sha256-vRedYg29QGPGW0hOX9qbRSIImh1d/SoDZHImDF2oqKM=";
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
