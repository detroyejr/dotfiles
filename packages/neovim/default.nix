# Bump to 0.13-dev

prev: final: {
  neovim-unwrapped = final.neovim-unwrapped.overrideAttrs (attrs: {
    version = "v0.13.0-dev";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "51d7d99fe7c3625f524b47f3f5d041c6a5895f81";
      hash = "sha256-8Jk/IN9f3dAPDV2A2/uYa+pyqjaBbiPJQ4moFWE4agE=";
    };
    postInstall = ''
      mv $out/share/applications/org.neovim.nvim.desktop $out/share/applications/nvim.desktop
    '';
  });
}
