{ config, ... }:
{
  virtualisation.docker.enable = true;

  hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
}
