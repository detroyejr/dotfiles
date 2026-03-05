{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.steam;
in
{
  config = lib.mkIf cfg.enable {
    programs.steam.package = pkgs.steam.override {
      extraEnv =
        if (config.hardware.nvidia.enabled) then
          {
            __NV_PRIME_RENDER_OFFLOAD = 1;
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
          }
        else
          { };
    };
    programs.gamemode.enable = true;

    # Extra game services.
    environment.systemPackages = with pkgs; [
      heroic
      mangohud
    ];
  };
}
