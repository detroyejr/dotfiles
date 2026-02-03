final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.12";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "0566767d7dbe5b2abce8d37aab85d328629b2cc7";
      hash = "sha256-RVMU3KOFxmp1z5XsEd5/eJJKYG3096/9uwqzsv5G9bs=";
    };
  });
}
