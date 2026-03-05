{
  config,
  lib,
  ...
}:
let
  cfg = config.services.virtualization;
in
{
  options.services.virtualization.enable = lib.mkEnableOption "virtualization service module";

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;

    programs.virt-manager.enable = config.virtualisation.libvirtd.enable;

    users.users.${config.defaultUser}.extraGroups =
      lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ lib.optionals config.virtualisation.docker.enable [ "docker" ];
  };
}
