# Track the latest 0.13-dev snapshot.

prev: final: {
  neovim-unwrapped = final.neovim-unwrapped.overrideAttrs (attrs: {
    version = "v0.13.0-dev";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "aee9105c8a0b409181eae7292f84c20b05a6847c";
      hash = "sha256-muao8JvYJsFyIN9XAtGWQhmGFz3s0myq45yQ8SNrGUg=";
    };
    postInstall = ''
      mv $out/share/applications/org.neovim.nvim.desktop $out/share/applications/nvim.desktop
    '';
    doCheck = false;
  });
}
