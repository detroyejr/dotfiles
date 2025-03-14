{
  pkgs,
  colorScheme,
  wallpaper,
  isNvidia,
  ...
}:
let
  slack = pkgs.makeDesktopItem {
    name = "slack";
    desktopName = "slack";
    exec = "${pkgs.slack}/bin/slack --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto --ozone-platform=wayland -s %U";
    icon = "${pkgs.slack}/share/pixmaps/slack.png";
  };
in
{
  imports = [
    ./eww.nix
    ./waybar.nix
    ./gtk.nix
    ./hyprlock.nix
    ./kitty.nix
    ./rofi.nix
    ./wezterm.nix
    ./yazi.nix
  ];

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    QT_AUTO_SCALE_SCREEN_FACTOR = "1";
  };

  home.file.".config/hypr/hyprland.conf".text = with colorScheme.colors; ''
    # change monitor to high resolution, the last argument is the scale factor
    monitor=eDP-1,preferred,auto,2
    monitor=,highres,auto,1
    debug:disable_logs = false
    # toolkit-specific scale
    env = BROWSER,firefox;
    env = EDITOR,nvim;
    env = GDK_SCALE,1
    env = MOZ_ENABLE_WAYLAND,1;
    env = NIXOS_OZONE_WL,1
    env = QT_QPA_PLATFORM,wayland;xcb
    env = QT_QPA_PLATFORMTHEME,qt5ct;
    env = QT_AUTO_SCALE_SCREEN_FACTOR,1
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env = TERMINAL,kitty;

    exec-once = hyprctl dispatch dpms on &
    exec-once = hyprpaper & swaync & waybar & hyprlock & kanshi &
    exec-once = hyprctl setcursor Bibata-Modern-Ice 14

    windowrule = float,^(Rofi)$
    windowrule = center,^(Rofi)$

    windowrule = float,^(thunar)$
    windowrule = center,^(thunar)$
    windowrule = size 70% 70%,^(thunar)$

    windowrule = float,^(Volume Control)$
    windowrule = move 100%-488 6%,^(Volume Control)$
    windowrule = size 400 560,^(Volume Control)$
    windowrule = animation slide,^(Volume Control)$

    windowrule = float,^(Plexamp)$
    windowrule = move 100%-488 6%,title:^(Plexamp)$
    windowrule = size 400 560,title:^(Plexamp)$
    windowrule = animation slide,^(Plexamp)$

    windowrulev2 = float,class:^(org.wezfurlong.wezterm)$
    windowrulev2 = tile,class:^(org.wezfurlong.wezterm)$

    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        touchpad {
            natural_scroll = yes
            scroll_factor = 0.5
        }

        sensitivity = 0
        repeat_rate = 80
        repeat_delay = 300
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

    gestures {
        workspace_swipe = off
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
    bind = $mainMod, F, centerwindow
    bind = $mainMod, F, resizeactive, exact 1200 700
    bind = $mainMod, F, togglefloating,
    bind = $mainMod, G, fullscreen
    bind = $mainMod, J, togglesplit, # dwindle
    bind = $mainMod, L, exec, bash -c "hyprlock"
    bind = $mainMod, N, exec, bash -c "swaync-client -t"
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, Q, exec, wezterm
    bind = $mainMod, R, exec, bash -c "if pgrep -x rofi > /dev/null; then kill $(pgrep -x rofi); else $HOME/.local/bin/rofi-launcher; fi"
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

  home.file.".config/hypr/hyprpaper.conf".text = ''
    splash = true
    preload = ${builtins.toString wallpaper}

    wallpaper = DP-7,${builtins.toString wallpaper}
    wallpaper = DP-8,${builtins.toString wallpaper}
    wallpaper = eDP-1,${builtins.toString wallpaper}
    wallpaper = HDMI-A-1,${builtins.toString wallpaper}
  '';

  home.file.".local/bin/disable-laptop" = {
    text = ''
      for display in `ps aux | grep -oE "/usr/bin/X\s[^ ]+" | cut -d " " -f 2`; do
          xset -display $display dpms force on;
      done

      if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
          export GDK_SCALE=1
          hyprctl keyword monitor "eDP-1, disable"
      fi
    '';
    executable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-hyperion
    ];
  };

  services = {
    kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "Samsung Electric Company S24F350 H4ZM900001";
              mode = "1920x1080@59.96";
              status = "enable";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        }
        {
          profile.name = "docked2";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL S2721QS BVR9513";
              mode = "3840x2160@59.94";
              scale = 2.0;
              status = "enable";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        }
        {
          profile.name = "docked3";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL S2721QS BVR9513";
              mode = "2560x1440@59.95";
              scale = 1.0;
              status = "enable";
            }
          ];
        }
      ];
    };
  };

  home.packages = with pkgs; [
    acpi
    alsa-utils
    anki
    bluez
    bluetuith
    calibre
    colorz
    discord
    dmenu
    element-desktop
    en-croissant
    grim
    hyperion-ng
    hyprpaper
    hyprpicker
    kanshi
    keepassxc
    libnotify
    libreoffice
    lutris
    networkmanager_dmenu
    nfs-utils
    obsidian
    pamixer
    pavucontrol
    playerctl
    # (plex-desktop.override {
    #   extraEnv =
    #     if isNvidia then
    #       {
    #         __NV_PRIME_RENDER_OFFLOAD = 1;
    #         __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    #         __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #         __VK_LAYER_NV_optimus = "NVIDIA_only";
    #       }
    #     else
    #       { };
    # })
    plexamp
    procps # replace GNU uptime.
    slack
    slurp
    socat
    swaynotificationcenter
    vlc
    mp4v2
    wireplumber
    wlr-randr
    wlsunset
    wofi-emoji
    wpgtk
    xdo
    xdotool
  ];
}
