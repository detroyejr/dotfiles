final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.12";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "5f22cf5af3425fb0d461bf82220a633bebe10932";
      hash = "sha256-T7MN/sbX+j4dCkmIqX1LERFWk11cSpr9CdTmuky+yLI=";
    };
  });
}
