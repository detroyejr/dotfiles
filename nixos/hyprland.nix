{
  inputs,
  system,
  pkgs,
  lib,
  config,
  isNvidia,
  ...

}:
{
  imports = [
    ./firefox.nix
    ./gtk.nix
    ./hyprlock.nix
    ./rofi.nix
    ./waybar.nix
    ./xdg.nix
  ];

  xdg.portal.config.common.default = "*";

  # FIXME: Some app don't respect my desktop theme.
  # Plex needs this to login/click on links.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.default.overrideAttrs (oldAttrs: {
      prePatch = ''
        cp ${../dotfiles/hyprland/Splashes.hpp} ./src/helpers/Splashes.hpp
      '';
    });
    xwayland = {
      enable = true;
    };
  };

  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "detroyejr";
      };
    };
    xserver = {
      enable = true;
      videoDrivers = lib.mkIf isNvidia [ "nvidia" ];
    };
  };
  security.pam.services.hyprlock.fprintAuth = config.services.fprintd.enable;

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    BROWSER = "firefox";
  };

  environment.etc = {
    "xdg/hypr/hyprland.conf".text = with config.colorScheme.colors; ''
      # change monitor to high resolution, the last argument is the scale factor

      $TERMINAL = wezterm

      monitor=eDP-1,preferred,auto,2
      monitor=HDMI-A-1,preferred,auto,2
      monitor=,highres,auto,1

      ${lib.optionalString (config.system.name == "potato") ''
        monitor=eDP-1,preferred,auto,1
      ''}

      debug:disable_logs = false
      # toolkit-specific scale
      env = BROWSER,firefox;
      env = TERMINAL,$TERMINAL;

      exec-once = hyprctl dispatch dpms on &
      exec-once = kanshi
      exec-once = hyprpaper
      exec-once = waybar
      exec-once = hyprlock
      exec-once = swaync
      exec-once = blueman-applet

      exec-once = $TERMINAL
      exec-once = [workspace 2 silent;] firefox
      exec-once = [workspace 3 silent;] obsidian

      windowrule = float,title:^(Rofi)$
      windowrule = center,title:^(Rofi)$

      windowrule = float,title:^(thunar)$
      windowrule = center,title:^(thunar)$
      windowrule = size 70% 70%,title:^(thunar)$

      windowrule = float,title:^(Volume Control)$
      windowrule = move 100%-488 6%,title:^(Volume Control)$
      windowrule = size 400 560,title:^(Volume Control)$
      windowrule = animation slide,title:^(Volume Control)$

      windowrule = float,title:^(Plexamp)$
      windowrule = move 100%-488 6%,title:^(Plexamp)$
      windowrule = size 400 560,title:^(Plexamp)$
      windowrule = animation slide,title:^(Plexamp)$

      windowrule = float,class:^(org.wezfurlong.wezterm)$
      windowrule = tile,class:^(org.wezfurlong.wezterm)$

      windowrulev2 = opacity 0.94, class:(firefox)

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =
          follow_mouse = 1
          sensitivity = 0
          repeat_rate = 80
          repeat_delay = 300
          touchpad {
              natural_scroll = ${if config.services.libinput.touchpad.naturalScrolling then "0" else "1"}
              scroll_factor = ${config.services.libinput.touchpad.accelSpeed}
              drag_lock = ${if config.services.libinput.touchpad.tappingDragLock then "1" else "0"}
          }
      }

      general {
          gaps_in = 2
          gaps_out = 7
          border_size = 2
          col.active_border = rgba(${base07}66)
          col.inactive_border = rgb(${base00})
          layout = dwindle
          allow_tearing = true
      }

      decoration {
          rounding = 5
          dim_inactive = false
      }

      animations {
          enabled = yes
          animation = windows, 1, 2, default, slide down
          animation = windowsOut, 1, 2, default, slide
          animation = border, 1, 2, default
          animation = borderangle, 1, 2, default
          animation = fade, 1, 2, default
          animation = workspaces, 1, 2, default
      }

      binds {
          allow_workspace_cycles = true
      }

      dwindle {
          pseudotile = yes
          preserve_split = yes
      }

      master {
          new_status = "slave"
      }

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = false
        col.splash = rgb(${base0D})
        focus_on_activate = true
      }

      device {
        name = steelseries-steelseries-sensei-310-esports-mouse
        sensitivity = -0.7
      }

      $mainMod = SUPER

      bind = $mainMod CTRL, P, exec, hyprpicker | wl-copy
      bind = $mainMod, PRINT, exec, grim
      bind = $mainMod SHIFT, PRINT, exec, grim -g "$(slurp)"
      bind = $mainMod SHIFT, E, exec, bash -c "if pgrep -x wofi-emoji > /dev/null; then pkill wofi-emoji; else wofi-emoji; fi"
      bind = $mainMod SHIFT, J, exec, bash -c "if pgrep -x @obsidian > /dev/null; then pkill obsidian; else obsidian; fi"
      bind = $mainMod SHIFT, K, exec, bash -c "if pgrep -x .keepassxc-wrap > /dev/null; then pkill keepassxc; else keepassxc; fi"
      bind = $mainMod, C, killactive,
      bind = $mainMod, E, exec, thunar
      bind = $mainMod, F, togglefloating,
      bind = $mainMod, F, resizeactive, exact 1300 850
      bind = $mainMod, F, centerwindow
      bind = $mainMod, G, fullscreen
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, L, exec, bash -c "hyprlock"
      bind = $mainMod, N, exec, bash -c "swaync-client -t"
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, Q, exec, wezterm
      bind = $mainMod, R, exec, bash -c "if pgrep -x rofi > /dev/null; then kill $(pgrep -x rofi); else rofi-launcher; fi"
      bind = CTRL ALT, Delete, exit

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      bind = $mainMod CTRL, h, movefocus, l
      bind = $mainMod CTRL, l, movefocus, r
      bind = $mainMod CTRL, k, movefocus, u
      bind = $mainMod CTRL, j, movefocus, d
      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Window
      binde = $mainMod CTRL, up,    resizeactive, 0 -20
      binde = $mainMod CTRL, down,  resizeactive, 0 20
      binde = $mainMod CTRL, right, resizeactive, 20 0
      binde = $mainMod CTRL, left,  resizeactive, -20 0
      binde = $mainMod ALT,  up,    moveactive, 0 -20
      binde = $mainMod ALT,  down,  moveactive, 0 20
      binde = $mainMod ALT,  right, moveactive, 20 0
      binde = $mainMod ALT,  left,  moveactive, -20 0
      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Minimize
      bind = $mainMod, m, exec, $HOME/.local/bin/bash/minimize

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Laptop
      bindl = , XF86MonBrightnessUp,     exec, brightnessctl set "10%+"
      bindl = , XF86MonBrightnessDown,   exec, brightnessctl set "10%-"
      bindl = , XF86AudioRaiseVolume,    exec, pamixer --increase 10 --set-limit 100
      bindl = , XF86AudioLowerVolume,    exec, pamixer --decrease 10
      bindl = , XF86AudioMute,           exec, pamixer --toggle-mute
      bindl  = , XF86AudioStop,           exec, playerctl stop
      bindl  = , XF86AudioPause,          exec, playerctl pause
      bindl  = , XF86AudioPrev,           exec, playerctl previous
      bindl  = , XF86AudioNext,           exec, playerctl next
      bindl  = , XF86AudioPlay,           exec, playerctl play-pause
    '';

    "xdg/hypr/hyprpaper.conf".text = ''
      splash = true
      preload = ${builtins.toString config.colorScheme.wallpaper}

      ${lib.optionalString (config.system.name == "skate") ''
        wallpaper = DP-1,${builtins.toString config.colorScheme.config.wallpaper}
      ''}

      wallpaper = DP-7,${builtins.toString config.colorScheme.wallpaper}
      wallpaper = DP-8,${builtins.toString config.colorScheme.wallpaper}
      wallpaper = eDP-1,${builtins.toString config.colorScheme.wallpaper}
      wallpaper = HDMI-A-1,${builtins.toString config.colorScheme.wallpaper}
    '';
  };

  # TODO: should these remain in hyprland or move to another file?
  programs.chromium = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-hyperion
    ];
  };

  users.users.detroyejr.packages = with pkgs; [
    acpi
    alsa-utils
    anki
    blueman
    bluez
    calibre
    chromium
    comskip
    colorz
    discord
    dmenu
    element-desktop
    grim
    hyperion-ng
    hyprpaper
    hyprpicker
    kanshi
    keepassxc
    libnotify
    libreoffice
    lutris
    mp4v2
    networkmanager_dmenu
    nfs-utils
    obsidian
    pamixer
    pavucontrol
    playerctl
    plex-desktop
    plex-htpc
    plexamp
    procps # replace GNU uptime.
    slack
    slurp
    socat
    swaynotificationcenter
    vlc
    wireplumber
    wlr-randr
    wlsunset
    wofi-emoji
    wpgtk
    xdo
    xdotool
  ];
}
