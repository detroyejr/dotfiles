# Track the latest 0.13-dev snapshot.

prev: final: {
  neovim-unwrapped = final.neovim-unwrapped.overrideAttrs (attrs: {
    version = "v0.13.0-dev";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "4ef4bed584a099d03ec7591306c33e1f81e68ae8";
      hash = "sha256-MAI/+9FBfcXGp3+a1XLH3sx0UgzwcOe1AzbYeib6MJw=";
    };
    postInstall = ''
      mv $out/share/applications/org.neovim.nvim.desktop $out/share/applications/nvim.desktop
    '';
    doCheck = false;
  });
}
