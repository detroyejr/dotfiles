{ ... }:
{
  programs.git = {
    enable = true;
    userName = "detroyejr";
    userEmail = "detroyejr@outlook.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.lazygit.enable = true;
}
