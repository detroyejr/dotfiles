{ config, pkgs, lib, fetchFromGitHub, colorScheme, wallpaper, ... }:
let
  chromium = pkgs.makeDesktopItem {
    name = "chromium";
    desktopName = "Chromium (web browser)";
    exec = "${pkgs.chromium}/bin/chromium --ozone-platform-hint=auto";
  };

  slack = pkgs.makeDesktopItem {
    name = "slack";
    desktopName = "slack";
    exec = "${pkgs.slack}/bin/slack --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto --ozone-platform=wayland -s %U";
  };

  plexamp = pkgs.makeDesktopItem {
    name = "plexamp";
    desktopName = "plexamp";
    exec = "${pkgs.plexamp}/bin/plexamp --ozone-platform-hint=auto";
  };

  plex-media-player = pkgs.makeDesktopItem {
    name = "plex";
    desktopName = "Plex Media Player (Media Player)";
    exec = "${pkgs.plex-media-player}/bin/plexmediaplayer";
  };
in
{
  imports = [
    # ./dunst.nix
    ./eww.nix
    ./gtk.nix
    ./kitty.nix
    ./rofi.nix
    ./swaylock.nix
  ];

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };

  home.file.".config/hypr/hyprland.conf".text = with colorScheme.colors; ''
    # change monitor to high resolution, the last argument is the scale factor
    monitor=eDP-1,preferred,auto,2
    monitor=,highres,auto,1

    # toolkit-specific scale
    env = BROWSER,firefox;
    env = EDITOR,nvim;
    env = GDK_SCALE,1
    env = MOZ_ENABLE_WAYLAND,1;
    env = NIXOS_OZONE_WL,1
    env = QT_QPA_PLATFORM,wayland;xcb;
    env = QT_QPA_PLATFORMTHEME,qt5ct;
    env = QT_AUTO_SCALE_SCREEN_FACTOR,1
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env = TERMINAL,kitty;
    env = XCURSOR_SIZE,32
    env = WLR_DRM_NO_ATOMIC,1

    exec-once = hyprctl dispatch dpms on &
    exec-once = kanshi & swaylock & hyprpaper & dunst & eww open bar &
    exec-once = hyprctl set-cursor Numix-Cursor 24

    windowrule = float,^(Rofi)$
    windowrule = center,^(Rofi)$

    windowrule = float,^(thunar)$
    windowrule = center,^(thunar)$
    windowrule = size 70% 70%,^(thunar)$

    windowrule = float,^(pavucontrol)$
    windowrule = move 100%-488 6%,^(pavucontrol)$
    windowrule = size 400 560,^(pavucontrol)$
    windowrule = animation slide,^(pavucontrol)$

    windowrule = float,^(Plexamp)$
    windowrule = move 100%-488 6%,title:^(Plexamp)$
    windowrule = size 400 560,title:^(Plexamp)$
    windowrule = animation slide,^(Plexamp)$

    windowrule = float,title:^(nmtui-connect)$
    windowrule = move 100%-488 6%,title:^(nmtui-connect)$
    windowrule = size 100 160,^(nmtui-connect)$
    windowrule = animation slide,title:^(nmtui-connect)$

    windowrule = float,title:(.*)(- KeePassXC)$
    windowrule = center,title:(.*)(- KeePassXC)$
    windowrule = animation popin,title:(.*)(- KeePassXC)$
    windowrule = size 70% 70%,title:(.*)(- KeePassXC)$
    windowrulev2 = immediate, class:^(Raft)$

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

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
        gaps_in = 4
        gaps_out = 8
        border_size = 2
        col.active_border = rgba(${base07}66)
        col.inactive_border = rgb(${base00})
        layout = dwindle
        allow_tearing = true
    }

    decoration {
        rounding = 5
        drop_shadow = yes
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(${base07}ee)
        dim_inactive = false
    }

    animations {
        enabled = yes

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    binds {
        allow_workspace_cycles = true
    }

    dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
    }

    master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true
    }

    gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = off
    }

    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
    }

    device:steelseries-steelseries-sensei-310-esports-mouse {
        sensitivity = -0.7
    }


    # See https://wiki.hyprland.org/Configuring/Keywords/ for more
    $mainMod = SUPER

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = $mainMod CTRL, S, exec, grim -g "$(slurp)"
    bind = $mainMod CTRL, P, exec, hyprpicker | wl-copy
    bind = $mainMod SHIFT, J, exec, bash -c "if pgrep -x @joplinapp-desk > /dev/null; then kill $(pgrep -x  @joplinapp-desk | paste -sd ' '); else joplin-desktop; fi"
    bind = $mainMod SHIFT, K, exec, bash -c "if pgrep -x .keepassxc-wrap > /dev/null; then kill $(pgrep -x .keepassxc-wrap); else keepassxc; fi"
    bind = $mainMod, C, killactive,
    bind = $mainMod, E, exec, thunar
    bind = $mainMod, F, togglefloating,
    bind = $mainMod, F, centerwindow
    bind = $mainMod, F, resizeactive, exact 1000 1200
    bind = $mainMod, G, fullscreen
    bind = $mainMod, J, togglesplit, # dwindle
    bind = $mainMod, L, exec, bash -c "swaylock"
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, R, exec, bash -c "if pgrep -x rofi > /dev/null; then kill $(pgrep -x rofi); else $HOME/.local/bin/rofi-launcher; fi"
    bind = $mainMod, R, exec, hyprctl dispatch focuswindow ^(Rofi)$
    bind = CTRL ALT, Delete, exit
    bind = $mainMod SHIFT, W, exec, bash -c "/home/detroyejr/.local/bin/bash//random-wallpaper /home/detroyejr/OneDrive/Pictures/Wallpaper/walls/ && eww close-all && eww open bar"

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
    splash = false
    preload = ${wallpaper}

    wallpaper = DP-3,${wallpaper}
    wallpaper = DP-4,${wallpaper}
    wallpaper = DP-5,${wallpaper}
    wallpaper = DP-7,${wallpaper}
    wallpaper = eDP-1,${wallpaper}
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
    package = chromium;
  };

  programs.thunderbird = {
    enable = true;
    profiles."Personal" = {
      isDefault = true;
    };
    profiles."Work" = { };
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
    dunst.enable = true;
    kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
        docked = {
          outputs = [
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
        };
        docked2 = {
          outputs = [
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
        };
      };
    };
  };

  home.packages = with pkgs; [
    acpi
    aircrack-ng
    anki
    bluez
    colorz
    discord
    dmenu
    eww-wayland
    grim
    hyperion-ng
    hyprpaper
    hyprpicker
    joplin
    joplin-desktop
    jq
    kanshi
    keepassxc
    keeweb
    lutris
    networkmanager_dmenu
    nomacs
    pamixer
    pavucontrol
    playerctl
    plex-media-player
    plexamp
    procps # replace GNU uptime.
    slack
    slurp
    socat
    swaynotificationcenter
    viewnior
    vlc
    wireplumber
    wireshark
    wlr-randr
    wlsunset
    wpgtk
    xdo
    xdotool
  ];
}
