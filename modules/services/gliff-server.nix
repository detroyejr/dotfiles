{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gliff;
in
{
  options.services.gliff = {
    enable = lib.mkEnableOption "Gliff remote desktop over SSH";

    package = lib.mkPackageOption pkgs "gliff" { };
  };

  config = lib.mkIf cfg.enable {
    # gliff starts gliff-server --stdio over SSH on demand; no daemon or
    # listening port is needed.
    environment.systemPackages = [ cfg.package ];
  };
}
