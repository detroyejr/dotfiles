final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.12";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "1e9143879d6b05bf7e4ed2a59d64d18418d2594f";
      hash = "sha256-oJCLtEd9uRG9mLdH/QYrpeZyr4UhE0WXBrsxKd/lcVU=";
    };
  });
}
