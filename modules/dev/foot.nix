{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.foot;
in
{

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      "TERMINAL" = "foot";
    };

    programs.foot.settings = {
      main = {
        font = "InputMono:size=14";
      };
    };
  };
}
