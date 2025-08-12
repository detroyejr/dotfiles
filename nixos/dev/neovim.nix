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
in
{
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  environment.etc = {
    "xdg/nvim".source = neovimConfig;
  };
}
