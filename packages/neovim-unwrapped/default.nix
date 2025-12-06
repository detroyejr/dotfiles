final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.12";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      tag = "nightly";
      hash = "sha256-AA3Pvn0k9lasHZzfW+raPgfWbR/wRLvVsNOISRoQmOU=";
    };
  });
}
