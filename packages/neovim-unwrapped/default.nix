final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.12";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "3a70fc8cb8fedf78b5e0d7c606d99967faad70ab";
      hash = "sha256-2vA/HHG7s/G19yWf9gAdBXIFRpgEdaOuml/55wOZA7c=";
    };
  });
}
