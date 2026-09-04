# Bump to 0.13-dev

prev: final: {
  neovim-unwrapped = final.neovim-unwrapped.overrideAttrs (attrs: {
    version = "v0.13.0-dev";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "5209695703db4096923c203f235d78aec0cbdec8";
      hash = "sha256-3K9uQyHP/G8EXvfBLmUq5acGa9EwfrsgbGtepS+UwSw=";
    };
    postInstall = ''
      mv $out/share/applications/org.neovim.nvim.desktop $out/share/applications/nvim.desktop
    '';
  });
}
