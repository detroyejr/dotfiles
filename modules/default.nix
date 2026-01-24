{ lib, ... }:
{
  imports = [ ./theme.nix ./xdg.nix ];
  options = {
    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = "detroyejr";
      description = "Primary username";
    };
  };
}
