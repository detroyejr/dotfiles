{ ... }:

{
  programs.git = {
    enable = true;
    config = {
      core = {
        editor = "nvim";
      };
      init.defaultBranch = "main";
      user = {
        name = "detroyejr";
        email = "detroyejr@outlook.com";
      };
      pull = {
        rebase = true;
      };
    };
  };
}
