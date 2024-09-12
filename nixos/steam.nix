{
  pkgs,
  lib,
  isNvidia,
  ...
}:
{
  programs = {
    steam = {
      enable = true;
      package = pkgs.steam-small.override {
        extraEnv =
          if isNvidia then
            {
              __NV_PRIME_RENDER_OFFLOAD = 1;
              __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
              __GLX_VENDOR_LIBRARY_NAME = "nvidia";
              __VK_LAYER_NV_optimus = "NVIDIA_only";
            }
          else
            { };
      };
    };
    gamemode.enable = true;
  };

  # Extra game services.
  environment.systemPackages = with pkgs; [
    heroic
    mangohud
  ];
}
