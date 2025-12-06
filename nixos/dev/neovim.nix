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
    rev = "75797cdd8ac125c7ace065b17788b439dcf89a71";
    hash = "sha256-KZifQVHVhw1ee4encXHo/U5OyaUU6C1fZhNm+Hu5jhE=";
  };
  sidekick = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "sidekick.nvim";
    rev = "c2bdf8cfcd87a6be5f8b84322c1b5052e78e302e";
    hash = "sha256-ABuILCcKfYViZoFHaCepgIMLjvMEb/SBmGqGHUBucAM=";
  };
in
{
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  environment.systemPackages = [ pkgs.tree-sitter pkgs.copilot-language-server ];
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

        mkdir -p ''${DIR}/nvim/site/pack/plugins/start/sidekick
        ln -sfn ${sidekick}/* ''${DIR}/nvim/site/pack/plugins/start/sidekick
      '';
    };
  };
}
