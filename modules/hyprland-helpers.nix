{
  pkgs,
  lib,
}:
let
  themeNames = {
    wall-etna = "rose-pine";
    wall-blue-mountain = "nord";
  };

  schemes = {
    rose-pine = {
      slug = "rose-pine";
      colors = rec {
        background = base00;
        foreground = base06;
        base00 = "191724";
        base01 = "1f1d2e";
        base02 = "26233a";
        base03 = "6e6a86";
        base04 = "908caa";
        base05 = "e0def4";
        base06 = "e0def4";
        base07 = "524f67";
        base08 = "eb6f92";
        base09 = "f6c177";
        base0A = "ebbcba";
        base0B = "31748f";
        base0C = "9ccfd8";
        base0D = "c4a7e7";
        base0E = "f6c177";
        base0F = "524f67";
      };
    };

    nord = {
      slug = "nord";
      colors = rec {
        background = base00;
        foreground = base06;
        base00 = "2E3440";
        base01 = "3B4252";
        base02 = "434C5E";
        base03 = "4C566A";
        base04 = "D8DEE9";
        base05 = "E5E9F0";
        base06 = "ECEFF4";
        base07 = "8FBCBB";
        base08 = "BF616A";
        base09 = "D08770";
        base0A = "EBCB8B";
        base0B = "A3BE8C";
        base0C = "88C0D0";
        base0D = "81A1C1";
        base0E = "B48EAD";
        base0F = "5E81AC";
      };
    };
  };

  repo = fetchGit {
    url = "https://github.com/Misterio77/nix-colors";
    rev = "37227f274b34a3b51649166deb94ce7fec2c6a4c";
  };

  nix-colors-lib = {
    gtkThemeFromScheme = import "${repo}/lib/contrib/gtk-theme.nix" { inherit pkgs; };
  };

  mkNextWallpaper =
    config:
    pkgs.writeScriptBin "next-wallpaper" ''
      #!/usr/bin/env bash

      # Collect paths into an array.
      export themePaths=(${lib.concatStringsSep " " config.themes})
      export themeName=(${lib.concatStringsSep " " (lib.attrNames themeNames)})
      export index=''$((RANDOM % ''${#themePaths[@]}))
      currentTheme="''${themePaths[''$index]}"
      if [ -d /etc/xdg/CURRENT_THEME ]; then
        unlink /etc/xdg/CURRENT_THEME
      fi;
      ln -s $currentTheme /etc/xdg/CURRENT_THEME

      for path in wezterm waybar hypr; do
        if [ -d "/etc/xdg/$path" ]; then
          unlink "/etc/xdg/$path"
        fi;
        ln -s "$currentTheme/$path" "/etc/xdg/$path"
      done;

      # GTK_THEME="''${themeName[''$index]}"

      hyprctl hyprpaper wallpaper ,''$currentTheme/wallpaper/wallpaper.jpg
      pkill waybar && hyprctl dispatch exec -- waybar --config $THEME/waybar/config --style $THEME/waybar/style.css
    '';

  mkHyprpaper =
    wall:
    pkgs.writeText "hyprpaper.conf" ''
      splash = true
      preload = ${toString wall}

      wallpaper {
          monitor =
          path = ${toString wall}
      }
    '';

  mkLockscreen =
    config: wall: scheme:
    pkgs.writeText "hyprlock.conf" ''
      background {
        monitor=
        blur_passes=1
        blur_size=7
        path=${wall}/wallpaper.jpg
      }

      image {
        monitor=
        size=${config.hyprlock.imageSize}
        halign=center
        path=${config.hyprlock.profile}
        position=${config.hyprlock.imagePosition}
        rounding=-1
        valign=center
      }

      input-field {
        monitor=
        size=${config.hyprlock.inputFieldSize}
        dots_size=0.300000
        dots_spacing=0.400000
        font_color=rgba(${scheme.colors.base04}FF)
        halign=center
        inner_color=rgba(${scheme.colors.base02}FF)
        outer_color=rgba(${scheme.colors.base09}FF)
        outline_thickness=2
         position=${config.hyprlock.inputFieldPosition}
        valign=center
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base06}FF)
        font_family=${config.font.name}
        font_size=65
        halign=center
        position=${config.hyprlock.labelPosition}
        rotate=0
        text=$TIME
        text_align=center
        valign=center
      }
    '';

  mkHyprlandConfig =
    config:
    pkgs.writeText "hyprland.conf" ''
      # change monitor to high resolution, the last argument is the scale factor

      $TERMINAL = wezterm

      monitor=eDP-1,preferred,auto,2
      monitor=,highres,auto,1

      ${lib.optionalString (config.system.name == "pelican") ''
        monitor=eDP-1,preferred,auto,1
      ''}

      debug:disable_logs = false
      # toolkit-specific scale
      env = TERMINAL,$TERMINAL;
      env = THEME,/etc/xdg/CURRENT_THEME


      exec-once = hyprctl dispatch dpms on &
      exec-once = kanshi
      exec-once = waybar
      exec-once = mako
      exec-once = blueman-applet
      exec-once = hyprpaper
      exec-once = hyprlock

      exec-once = $TERMINAL
      ${lib.optionalString config.programs.firefox.enable "exec-once = [workspace 2 silent;] firefox"}
      exec-once = [workspace 3 silent;] obsidian
      exec-once = [workspace 9 silent;] sleep 30 && keepass

      windowrule = match:title .*KeePass$, float yes
      windowrule = match:title .*KeePass$, center yes

      windowrule = match:title ^(Rofi)$, float yes
      windowrule = match:title ^(Rofi)$, center yes

      windowrule = match:class thunar, float yes
      windowrule = match:class thunar, center yes
      windowrule = match:class thunar, size 70% 70%

      windowrule = match:title ^(Volume Control)$, float yes
      windowrule = match:title ^(Volume Control)$, move 100%-488 6%
      windowrule = match:title ^(Volume Control)$, size 400 560
      windowrule = match:title ^(Volume Control)$, animation slide

      windowrule = match:title ^(Plexamp)$, float yes
      windowrule = match:title ^(Plexamp)$, move 100%-488 6%
      windowrule = match:title ^(Plexamp)$, size 400 560
      windowrule = match:title ^(Plexamp)$, animation slide

      windowrule = match:class ^(org.wezfurlong.wezterm)$, float yes
      windowrule = match:class ^(org.wezfurlong.wezterm)$, tile yes

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
          col.active_border = rgba(524f6766)
          col.inactive_border = rgb(191724)
          layout = dwindle
          allow_tearing = true
      }

      decoration {
          rounding = 5
          dim_inactive = false
      }

      animations {
          enabled = no
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
        col.splash = rgb(c4a7e7)
        focus_on_activate = true
      }

      device {
        name = steelseries-steelseries-sensei-310-esports-mouse
        sensitivity = -0.7
      }

      $mainMod = SUPER

      bind = $mainMod CTRL, P, exec, hyprpicker | wl-copy
      bind = $mainMod SHIFT, E, exec, bash -c "if pgrep -x wofi-emoji > /dev/null; then pkill wofi-emoji; else wofi-emoji; fi"
      bind = $mainMod SHIFT, J, exec, bash -c "if pgrep -x @obsidian > /dev/null; then pkill obsidian; else obsidian; fi"
      bind = $mainMod SHIFT, K, exec, bash -c "if pgrep -x mono > /dev/null; then pkill mono; else keepass; fi"
      bind = $mainMod SHIFT, PRINT, exec, grim -g "$(slurp)"
      bind = $mainMod SHIFT, T, exec, source next-wallpaper
      bind = $mainMod, C, killactive,
      bind = $mainMod, E, exec, thunar
      bind = $mainMod, F, centerwindow
      bind = $mainMod, F, resizeactive, exact 1300 850
      bind = $mainMod, F, togglefloating,
      bind = $mainMod, G, fullscreen
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, L, exec, bash -c "hyprlock"
      bind = $mainMod, N, exec, bash -c "swaync-client -t"
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, PRINT, exec, grim
      bind = $mainMod, Q, exec, wezterm
      bind = $mainMod, R, exec, bash -c "if pgrep -x rofi > /dev/null; then kill $(pgrep -x rofi); else $THEME/rofi/bin/rofi-launcher; fi"
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

  mkWeztermConfig =
    scheme: font:
    with scheme.colors;
    pkgs.writeText "wezterm.lua" ''
      local wezterm = require 'wezterm'

      config = {
        colors = {
          ansi = {
              "#${base00}",
              "#${base08}",
              "#${base0B}",
              "#${base0A}",
              "#${base0D}",
              "#${base0E}",
              "#${base0C}",
              "#${base05}",
          },
          background = "#${base00}",
          brights = {
              "#${base03}",
              "#${base08}",
              "#${base0B}",
              "#${base0A}",
              "#${base0D}",
              "#${base0E}",
              "#${base0C}",
              "#${base07}",
          },
          compose_cursor = "#${base05}",
          cursor_bg = "#${base05}",
          cursor_fg = "#${base00}",
          foreground = "#${base05}",
          scrollbar_thumb = "#${base01}",
          selection_bg = "#${base05}",
          selection_fg = "#${base00}",
          split = "#${base03}",
          visual_bell = "#${base0E}",
          tab_bar = {
            background = "#${base01}",
            inactive_tab_edge = "#${base01}",
            active_tab = {
              bg_color = "#${base00}",
              fg_color = "#${base05}"
            },
            inactive_tab_hover = {
              bg_color = "#${base03}",
              fg_color = "#${base05}"
            },
            new_tab = {
              bg_color = "#${base05}",
              fg_color = "#${base00}"
            },
            new_tab_hover = {
              bg_color = "#${base05}",
              fg_color = "#${base00}"
            }
          }
        },
        cursor_blink_rate = 0,
        enable_wayland = true,
        keys = {
          {
            key = 'u',
            mods = 'SHIFT|CTRL',
            action = wezterm.action.DisableDefaultAssignment
          },
        },
        font = wezterm.font("${font.name}"),
        font_size = 14,
        use_fancy_tab_bar = false,
        warn_about_missing_glyphs = false,
        window_background_opacity = 0.8,
        window_frame = {
            active_titlebar_bg = "#${base03}",
            active_titlebar_fg = "#${base05}",
            active_titlebar_border_bottom = "#${base03}",
            border_left_color = "#${base01}",
            border_right_color = "#${base01}",
            border_bottom_color = "#${base01}",
            border_top_color = "#${base01}",
            button_bg = "#${base01}",
            button_fg = "#${base05}",
            button_hover_bg = "#${base05}",
            button_hover_fg = "#${base03}",
            inactive_titlebar_bg = "#${base01}",
            inactive_titlebar_fg = "#${base05}",
            inactive_titlebar_border_bottom = "#${base03}",
        },
        command_palette_bg_color = "#${base01}",
        command_palette_fg_color = "#${base05}",
      }
      return config
    '';

  mkRofiTheme =
    walls: scheme: font:
    pkgs.rofi-themes.overrideAttrs (attrs: {
      pname = "rofi-theme-${walls.name}";
      version = "1.0";
      src = pkgs.rofi-themes;
      buildInputs = [ pkgs.imagemagick ];

      patchPhase = ''
        # Rofi opens much faster when the wallpaper is a more manageable size.
        magick "${walls}/wallpaper.jpg" -resize 800x600^ "rofi.png"

        # Patch font, colors, and wallpaper.
        find files -type f -name "*.rasi" -exec sed -i 's/font:.*$/font: "${font.name} #${font.size}";/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/background:.*$/background: #${scheme.colors.base00};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/background-alt:.*$/background-alt: #${scheme.colors.base01};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/foreground:.*$/foreground: #${scheme.colors.base06};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/selected:.*$/selected: #${scheme.colors.base02};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/active:.*$/active: #${scheme.colors.base04};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/urgent:.*$/urgent: #${scheme.colors.base01};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/[a-j].png/wallpaper.png/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/[a-j].jpg/wallpaper.png/g' {} ';';
        find files -type f -name "*.rasi" -exec \
          sed -i "s,~/.config/rofi/images/wallpaper.png,$out/rofi.png,g" {} ';';

        mkdir -p $out/bin
        cat << EOF > $out/bin/rofi-launcher
          rofi \
            -show drun \
            -theme $out/files/launchers/type-6/style-3.rasi
        EOF
        chmod +x $out/bin/rofi-launcher
      '';
    });

  mkTheme =
    config: wall: scheme: font:
    let
      hyprlandConfig = mkHyprlandConfig config;
    in
    pkgs.stdenv.mkDerivation {
      name = "theme-${wall.name}";
      version = "1.0";
      src = null;

      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/hypr $out/waybar $out/mako $out/wezterm/colors
        ln -sfn ${wall} $out/wallpaper
        ln -sfn ${mkRofiTheme wall scheme font} $out/rofi
        ln -sfn ${mkLockscreen config wall scheme} $out/hypr/hyprlock.conf
        ln -sfn ${mkHyprpaper wall} $out/hypr/hyprpaper.conf
        ln -sfn ${hyprlandConfig} $out/hypr/hyprland.conf

        cat << EOF > $out/waybar/config.css
          @define-color background #${scheme.colors.background};
          @define-color foreground #${scheme.colors.foreground};
          @define-color accent #${scheme.colors.base08};
          @define-color highlight #${scheme.colors.base0D};
        EOF

        ln -sfn ${../dotfiles/waybar/config} $out/waybar/config
        ln -sfn ${../dotfiles/waybar/style.css} $out/waybar/style.css
        ln -sfn ${../dotfiles/mako/mako.ini} $out/mako/mako.ini
        ln -sfn ${mkWeztermConfig scheme font} $out/wezterm/wezterm.lua
        ln -sfn ${nix-colors-lib.gtkThemeFromScheme { scheme = schemes.${scheme.slug}; }} $out/gtk

        echo "${scheme.slug}" > $out/THEME
      '';
    };

in
{
  inherit
    themeNames
    schemes
    nix-colors-lib
    mkNextWallpaper
    mkHyprpaper
    mkLockscreen
    mkHyprlandConfig
    mkWeztermConfig
    mkRofiTheme
    mkTheme
    ;
}
