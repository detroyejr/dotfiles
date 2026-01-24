{ config, ... }:
{
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
  programs.virt-manager.enable = true;

  users.users.${config.defaultUser}.extraGroups = [
    "docker"
    "libvirtd"
  ];
}
