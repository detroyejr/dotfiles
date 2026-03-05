{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.hyprland;
in
{
  options = {
    hyprlock = {
      profile = lib.mkOption {
        default = ../dotfiles/profile.png;
        type = lib.types.path;
        description = "User profile image used by modules (e.g. hyprlock).";
      };
      imageSize = lib.mkOption {
        default = "400";
        type = lib.types.str;
        description = "Profile image size used by hyprlock (px).";
      };
      imagePosition = lib.mkOption {
        default = "0,270";
        type = lib.types.str;
        description = "Profile image position for hyprlock (x,y).";
      };
      inputFieldSize = lib.mkOption {
        default = "350, 90";
        type = lib.types.str;
        description = "Input-field size used by hyprlock (width, height).";
      };
      inputFieldPosition = lib.mkOption {
        default = "0, -130";
        type = lib.types.str;
        description = "Input-field position used by hyprlock (x, y).";
      };
      labelPosition = lib.mkOption {
        default = "0,550";
        type = lib.types.str;
        description = "Label position used by hyprlock (x,y).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock.enable = true;

    security.pam.services.hyprlock = lib.mkIf config.services.fprintd.enable {
      fprintAuth = true;
      text = ''
        # Account management.
        account required pam_unix.so

        # Authentication management.
        auth sufficient pam_unix.so   likeauth try_first_pass nullok
        auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so # fprintd (order 11400)
        auth required pam_deny.so

        # Password management.
        password sufficient pam_unix.so nullok sha512

        # Session management.
        session required pam_env.so conffile=/etc/pam/environment readenv=0
        session required pam_unix.so
      '';
    };

    hyprlock = lib.mkIf (config.system.name == "pelican") {
      imageSize = lib.mkDefault "300";
      imagePosition = lib.mkDefault "0,100";
      inputFieldSize = lib.mkDefault "250, 80";
      inputFieldPosition = lib.mkDefault "0, -130";
      labelPosition = lib.mkDefault "0,350";
    };
  };
}
