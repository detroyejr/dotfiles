{ ... }:
{
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
  programs.virt-manager.enable = true;

  users.users.detroyejr.extraGroups = [
    "docker"
    "libvirtd"
  ];
}
