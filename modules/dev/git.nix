{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.git;
in

{
  config = lib.mkIf cfg.enable {
    programs.git = {
      config = {
        core = {
          autocrlf = "input";
          core.autocrlf = true;
          editor = "nvim";
          eol = "lf";
          fileMode = false;
        };
        merge = {
          tool = "nvimdiff";
          keepBackup = false;
        };
        diff = {
          tool = "nvimdiff";
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
  };
}
