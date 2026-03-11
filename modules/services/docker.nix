{
  config,
  lib,
  ...
}:
let
  cfg = config.services.docker;
in
{
  options.services.docker.enable = lib.mkEnableOption "docker service module";

  config = lib.mkIf cfg.enable {
    users.users.${config.defaultUser}.extraGroups = [ "docker" ];
    virtualisation.docker.enable = true;
    hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
  };
}
