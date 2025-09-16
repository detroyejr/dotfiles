{ ... }:

{
  programs.git = {
    enable = true;
    config = {
      core = {
        editor = "nvim";
        core.autocrlf = true;
        autocrlf = "input";
        eol = "lf";
      };
      init.defaultBranch = "main";
      user = {
        name = "detroyejr";
        email = "detroyejr@outlook.com";
      };
      pull = {
        rebase = true;
      };
      # NOTE: Root does not own this directory therefore it's unsafe.
      safe = {
        directory = [ "/home/detroyejr/.config/dotfiles" ];
      };
    };
  };
}
