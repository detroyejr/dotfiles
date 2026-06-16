{
  pkgs,
  lib,
}:
let
  rendersvg = pkgs.runCommand "rendersvg" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.resvg}/bin/resvg $out/bin/rendersvg
  '';

  themeNames = {
    wall-etna = "rose-pine";
    wall-blue-mountain = "nord";
    wall-orange-mountain = "everforest";
    wall-ibm-background-1 = "ibm-thinkpad";
  };

  themeLabels = {
    rose-pine = "Rose Pine";
    nord = "Nord";
    everforest = "Everforest";
    ibm-thinkpad = "IBM ThinkPad";
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

    everforest = {
      slug = "everforest";
      colors = rec {
        background = base00;
        foreground = base06;
        base00 = "2f383e";
        base01 = "374247";
        base02 = "4a555b";
        base03 = "859289";
        base04 = "9da9a0";
        base05 = "d3c6aa";
        base06 = "e4e1cd";
        base07 = "fdf6e3";
        base08 = "7fbbb3";
        base09 = "d699b6";
        base0A = "dbbc7f";
        base0B = "83c092";
        base0C = "e69875";
        base0D = "a7c080";
        base0E = "e67e80";
        base0F = "eaedc8";
      };
    };

    ibm-thinkpad = {
      slug = "ibm-thinkpad";
      colors = rec {
        background = base00;
        foreground = base06;
        base00 = "050709";
        base01 = "4a4a4a";
        base02 = "727272";
        base03 = "4a4a4a";
        base04 = "adadad";
        base05 = "ffffff";
        base06 = "ffffff";
        base07 = "ffffff";
        base08 = "d24646";
        base09 = "993426";
        base0A = "b4b47b";
        base0B = "66a773";
        base0C = "a360a3";
        base0D = "727272";
        base0E = "8686ba";
        base0F = "c296c2";
      };
    };
  };

  # From https://github.com/Misterio77/nix-colors/blob/main/lib/contrib/gtk-theme.nix
  gtkThemeFromScheme =
    scheme:
    pkgs.stdenv.mkDerivation {
      name = "generated-gtk-theme-${scheme.slug}";
      src = pkgs.fetchFromGitHub {
        owner = "nana-4";
        repo = "materia-theme";
        rev = "76cac96ca7fe45dc9e5b9822b0fbb5f4cad47984";
        sha256 = "sha256-0eCAfm/MWXv6BbCl2vbVbvgv8DiUH09TAUhoKq7Ow0k=";
      };
      buildInputs = [
        pkgs.bc
        pkgs.gtk4.dev
        pkgs.meson
        pkgs.ninja
        pkgs.nodejs
        pkgs.optipng
        pkgs.sassc
        pkgs.which
        rendersvg
      ];
      phases = [
        "unpackPhase"
        "patchPhase"
        "installPhase"
      ];

      patchPhase = with pkgs; ''
        substituteInPlace \
          meson.build \
          --replace-fail \
          "find_program('./node_modules/.bin/sass')" \
          "find_program('${dart-sass}/bin/sass')"
      '';

      installPhase = ''
        HOME=/build
        chmod 777 -R .
        patchShebangs .
        mkdir -p $out/share/themes
        mkdir bin
        sed -e 's/handle-horz-.*//' -e 's/handle-vert-.*//' -i ./src/gtk-2.0/assets.txt

        cat > /build/gtk-colors << EOF
          BTN_BG=${scheme.colors.base02}
          BTN_FG=${scheme.colors.base06}
          FG=${scheme.colors.base05}
          BG=${scheme.colors.base00}
          HDR_BTN_BG=${scheme.colors.base01}
          HDR_BTN_FG=${scheme.colors.base05}
          ACCENT_BG=${scheme.colors.base0B}
          ACCENT_FG=${scheme.colors.base00}
          HDR_FG=${scheme.colors.base05}
          HDR_BG=${scheme.colors.base02}
          MATERIA_SURFACE=${scheme.colors.base02}
          MATERIA_VIEW=${scheme.colors.base01}
          MENU_BG=${scheme.colors.base02}
          MENU_FG=${scheme.colors.base06}
          SEL_BG=${scheme.colors.base0D}
          SEL_FG=${scheme.colors.base0E}
          TXT_BG=${scheme.colors.base02}
          TXT_FG=${scheme.colors.base06}
          WM_BORDER_FOCUS=${scheme.colors.base05}
          WM_BORDER_UNFOCUS=${scheme.colors.base03}
          UNITY_DEFAULT_LAUNCHER_STYLE=False
          NAME=${scheme.slug}
          MATERIA_STYLE_COMPACT=True
        EOF

        echo "Changing colours:"
        ./change_color.sh -o ${scheme.slug} /build/gtk-colors -i False -t "$out/share/themes"
        chmod 555 -R .
      '';
    };

  mkNextWallpaper =
    config:
    let
      setTheme = mkSetTheme config;
    in
    pkgs.writeScriptBin "next-wallpaper" ''
      #!/usr/bin/env bash

      exec ${setTheme}/bin/set-theme --random
    '';

  mkSetTheme =
    config:
    pkgs.writeScriptBin "set-theme" ''
      #!/usr/bin/env bash
      set -euo pipefail

      themePaths=(${lib.concatMapStringsSep " " toString config.themes})

      activate_theme() {
        local currentTheme="$1"

        [ -z "$currentTheme" ] && exit 1

        if [ -L /etc/xdg/CURRENT_THEME ]; then
          unlink /etc/xdg/CURRENT_THEME
        fi
        ln -s "$currentTheme" /etc/xdg/CURRENT_THEME

        for path in wezterm waybar hypr mako; do
          if [ -L "/etc/xdg/$path" ]; then
            unlink "/etc/xdg/$path"
          fi
          ln -s "$currentTheme/$path" "/etc/xdg/$path"
        done

        if command -v hyprctl > /dev/null 2>&1; then
          hyprctl hyprpaper wallpaper ,"$currentTheme/wallpaper/wallpaper.jpg"
          pkill waybar || true
          hyprctl dispatch 'hl.dsp.exec_cmd("waybar --config /etc/xdg/CURRENT_THEME/waybar/config --style /etc/xdg/CURRENT_THEME/waybar/style.css")'

          # Hyprland will reload environment variables (GTK_THEME) in
          # hyprland.lua.
          hyprctl reload --quiet
        fi
      }

      case "''${1:-}" in
        --random)
          index=$((RANDOM % ''${#themePaths[@]}))
          activate_theme "''${themePaths[$index]}"
          ;;
        *)
          activate_theme "''${1:-}"
          ;;
      esac
    '';

  mkRofiThemeSelector =
    config:
    let
      setTheme = mkSetTheme config;
      labels = map (wall: themeLabels.${themeNames.${wall.name}}) config.walls;
    in
    pkgs.writeScriptBin "rofi-theme-mode" ''
      #!/usr/bin/env bash
      set -euo pipefail

      themePaths=(${lib.concatMapStringsSep " " toString config.themes})
      themeLabels=(${lib.concatMapStringsSep " " lib.escapeShellArg labels})

      if [ "''${ROFI_RETV:-0}" = "0" ]; then
        printf '\0no-custom\x1ftrue\n'
        printf '\0prompt\x1fTheme\n'
        printf '%s\n' "''${themeLabels[@]}"
        exit 0
      fi

      selection="''${1:-}"
      [ -z "$selection" ] && exit 0

      for index in "''${!themeLabels[@]}"; do
        if [ "''${themeLabels[$index]}" = "$selection" ]; then
          exec ${setTheme}/bin/set-theme "''${themePaths[$index]}"
        fi
      done
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
    let
      lockTime = pkgs.writeShellScript "hyprlock-time" ''
        ${pkgs.coreutils}/bin/date +%H:%M:%S
      '';
      lockDate = pkgs.writeShellScript "hyprlock-date" ''
        ${pkgs.coreutils}/bin/date '+%A, %B %d'
      '';
      lockWeather = pkgs.writeShellScript "hyprlock-weather" ''
        weather="$(${pkgs.curl}/bin/curl -fsS --max-time 2 'https://wttr.in/?format=%c|%t&u' 2>/dev/null || true)"
        icon="''${weather%%|*}"
        temperature="''${weather#*|}"
        icon="''${icon// /}"
        temperature="''${temperature//+/}"
        temperature="''${temperature// /}"
        [ -n "$icon" ] && [ -n "$temperature" ] && printf 'Outside%s %s\n' "$icon" "$temperature"
      '';
      lockSplash = pkgs.writeShellScript "hyprlock-splash" ''
        ${pkgs.hyprland}/bin/hyprctl splash 2>/dev/null | ${pkgs.coreutils}/bin/fold -s -w 90 || true
      '';
      lockMedia = pkgs.writeShellScript "hyprlock-media" ''
        status="$(${pkgs.playerctl}/bin/playerctl status 2>/dev/null || true)"
        case "$status" in
          Playing|Paused) ;;
          *) exit 0 ;;
        esac

        artist="$(${pkgs.playerctl}/bin/playerctl metadata --format '{{artist}}' 2>/dev/null || true)"
        title="$(${pkgs.playerctl}/bin/playerctl metadata --format '{{title}}' 2>/dev/null || true)"

        if [ -n "$artist" ] && [ -n "$title" ]; then
          printf 'Now Playing  %s - %s\n' "$artist" "$title" | ${pkgs.coreutils}/bin/fold -s -w 56
        elif [ -n "$title" ]; then
          printf 'Now Playing  %s\n' "$title" | ${pkgs.coreutils}/bin/fold -s -w 56
        else
          printf 'Now Playing\n'
        fi
      '';
      lockMediaButton = pkgs.writeShellScript "hyprlock-media-button" ''
        status="$(${pkgs.playerctl}/bin/playerctl status 2>/dev/null || true)"
        case "$status" in
          Playing|Paused) ;;
          *) exit 0 ;;
        esac

        case "''${1:-}" in
          previous) printf '⏮\n' ;;
          toggle)
            if [ "$status" = "Playing" ]; then
              printf '⏸\n'
            else
              printf '▶\n'
            fi
            ;;
          next) printf '⏭\n' ;;
        esac
      '';
      lockMediaControl = pkgs.writeShellScript "hyprlock-media-control" ''
        ${pkgs.playerctl}/bin/playerctl "''${1:-}" 2>/dev/null || true
        ${pkgs.procps}/bin/pkill -USR2 hyprlock 2>/dev/null || true
      '';
    in
    pkgs.writeText "hyprlock.conf" ''
      background {
        monitor=
        blur_passes=3
        blur_size=8
        brightness=0.62
        contrast=0.98
        noise=0.0117
        path=${wall}/wallpaper.jpg
        vibrancy=0.22
        vibrancy_darkness=0.45
      }

      input-field {
        monitor=
        size=${config.hyprlock.inputFieldSize}
        check_color=rgba(${scheme.colors.base0B}CC)
        dots_center=true
        dots_size=0.22
        dots_spacing=0.28
        fade_on_empty=false
        fail_color=rgba(${scheme.colors.base08}CC)
        font_color=rgba(${scheme.colors.base06}FF)
        halign=center
        inner_color=rgba(${scheme.colors.base00}99)
        outer_color=rgba(${scheme.colors.base09}D9)
        outline_thickness=1
        placeholder_text=<span foreground="##${scheme.colors.base04}">enter password</span>
        position=${config.hyprlock.inputFieldPosition}
        rounding=18
        valign=center
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base06}FF)
        font_family=${config.font.name}
        font_size=78
        halign=center
        position=${config.hyprlock.labelPosition}
        rotate=0
        text=cmd[update:1000] ${lockTime}
        text_align=center
        valign=center
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base04}FF)
        font_family=${config.font.name}
        font_size=22
        halign=center
        position=0, -44
        rotate=0
        text=cmd[update:60000] ${lockDate}
        text_align=center
        valign=top
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base04}EE)
        font_family=${config.font.name}
        font_size=12
        halign=center
        position=0, -205
        rotate=0
        text=cmd[update:1000] ${lockMedia}
        text_align=center
        valign=center
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base06}EE)
        font_family=${config.font.name}
        font_size=16
        halign=center
        onclick=${lockMediaControl} previous
        position=-48, -235
        rotate=0
        text=cmd[update:1000] ${lockMediaButton} previous
        text_align=center
        valign=center
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base09}EE)
        font_family=${config.font.name}
        font_size=16
        halign=center
        onclick=${lockMediaControl} play-pause
        position=0, -235
        rotate=0
        text=cmd[update:1000] ${lockMediaButton} toggle
        text_align=center
        valign=center
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base06}EE)
        font_family=${config.font.name}
        font_size=16
        halign=center
        onclick=${lockMediaControl} next
        position=48, -235
        rotate=0
        text=cmd[update:1000] ${lockMediaButton} next
        text_align=center
        valign=center
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base04}DD)
        font_family=${config.font.name}
        font_size=${config.hyprlock.bottomInfoFontSize}
        halign=left
        position=32, 20
        rotate=0
        text=${config.system.name}
        text_align=left
        valign=bottom
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base09}EE)
        font_family=${config.font.name}
        font_size=${config.hyprlock.bottomInfoFontSize}
        halign=right
        position=-32, 20
        rotate=0
        text=cmd[update:600000] ${lockWeather}
        text_align=right
        valign=bottom
      }

      label {
        monitor=
        color=rgba(${scheme.colors.base04}CC)
        font_family=${config.font.name}
        font_size=${config.hyprlock.splashFontSize}
        halign=center
        position=0, 20
        rotate=0
        text=cmd[update:0] ${lockSplash}
        text_align=center
        valign=bottom
      }
    '';
  mkHyprlandConfig =
    config: themeName:
    pkgs.writeText "hyprland.lua" ''
      local terminal = "wezterm"
      local mainMod = "SUPER"

      hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2 })
      hl.monitor({ output = "", mode = "highres", position = "auto", scale = 1 })

      if "${config.system.name}" == "pelican" then
        hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.2 })
      end

      hl.env("TERMINAL", terminal)
      hl.env("THEME", "/etc/xdg/CURRENT_THEME")
      hl.env("GTK_DATA_PREFIX", "/etc/xdg/CURRENT_THEME/gtk")
      hl.env("GTK_THEME", "${themeName}")

      hl.on("hyprland.start", function () 
        hl.exec_cmd(terminal)
        hl.exec_cmd("kanshi & mako --config /etc/xdg/mako/mako.ini & blueman-applet & hyprpaper")
        hl.exec_cmd("hyprctl dispatch dpms on")

        ${lib.optionalString config.programs.firefox.enable ''
          hl.exec_cmd("firefox", { workspace = "2 silent" })
        ''}

        hl.exec_cmd("obsidian", { workspace = "3 silent" })
        hl.exec_cmd("sleep 30 && keepass", { workspace = "9 silent" })
        hl.exec_cmd("hyprlock")
      end)

      hl.device({
        name = "steelseries-steelseries-sensei-310-esports-mouse",
        sensitivity = -0.7,
      })

      hl.window_rule({
        name = "keepass-float",
        match = { title = ".*KeePass$" },
        float = true,
        center = true,
      })

      hl.window_rule({
        name = "rofi-float",
        match = { title = "^(Rofi)$" },
        float = true,
        center = true,
      })

      hl.window_rule({
        name = "thunar-float",
        match = { class = "thunar" },
        float = true,
        center = true,
        size = "70% 70%",
      })

      hl.window_rule({
        name = "volume-control-float",
        match = { title = "^(Volume Control)$" },
        float = true,
        move = "100%-488 6%",
        size = "400 560",
        animation = "slide",
      })

      hl.window_rule({
        name = "plexamp-float",
        match = { title = "^(Plexamp)$" },
        float = true,
        move = "100%-488 6%",
        size = "400 560",
        animation = "slide",
      })

      hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
      hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
      hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("bash -c \"if pgrep -x wofi-emoji > /dev/null; then pkill wofi-emoji; else wofi-emoji; fi\""))
      hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("bash -c \"if pgrep -x @obsidian > /dev/null; then pkill obsidian; else obsidian; fi\""))
      hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("bash -c \"if pgrep -x mono > /dev/null; then pkill mono; else keepass; fi\""))
      hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("grim -g \"$(slurp)\""))
      hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("next-wallpaper"))
      hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + C", hl.dsp.window.close())
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
      hl.bind(mainMod .. " + F", function()
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        hl.dispatch(hl.dsp.window.center())
        hl.dispatch(hl.dsp.window.resize({ x = 1300, y = 850 }))
      end)
      hl.bind(mainMod .. " + G", hl.dsp.window.fullscreen())
      hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
      hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("bash -c \"hyprlock\""))
      hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("bash -c \"swaync-client -t\""))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("grim"))

      hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("if pgrep -x rofi > /dev/null; then kill $(pgrep -x rofi); else $THEME/rofi/bin/rofi-launcher; fi"))

      hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

      hl.bind(mainMod .. " + CTRL + h", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + CTRL + l", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + CTRL + k", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + CTRL + j", hl.dsp.focus({ direction = "down" }))

      -- Move active window to a workspace with mainMod + SHIFT + [0-9]
      for i = 1, 10 do
          local key = i % 10
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20 }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20 }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0 }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0 }), { repeating = true })
      hl.bind(mainMod .. " + ALT + up", hl.dsp.window.move({ x = 0, y = -20 }), { repeating = true })
      hl.bind(mainMod .. " + ALT + down", hl.dsp.window.move({ x = 0, y = 20 }), { repeating = true })
      hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ x = 20, y = 0 }), { repeating = true })
      hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ x = -20, y = 0 }), { repeating = true })

      hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("$HOME/.local/bin/bash/minimize"))
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set '10%+'"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set '10%-'"), { locked = true, repeating = true })
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer --increase 10 --set-limit 100"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer --decrease 10"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer --toggle-mute"), { locked = true, repeating = true })
      hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

       hl.config({
           input = {
             kb_layout = "us",
            kb_variant = "",
            kb_model = "",
            kb_options = "",
            kb_rules = "",
            follow_mouse = 1,
            sensitivity = 0,
            repeat_rate = 80,
            repeat_delay = 300,
            touchpad = {
              natural_scroll = ${
                if config.services.libinput.touchpad.naturalScrolling then "false" else "true"
              },
              scroll_factor = ${toString config.services.libinput.touchpad.accelSpeed},
              drag_lock = ${
                if config.services.libinput.touchpad.tappingDragLock then "true" else "false"
              },
            },
          },
          general = {
              gaps_in  = 2,
              gaps_out = 7,
              border_size = 2,
              col = {
                  active_border = "rgba(524f6766)",
                  inactive_border = "rgb(191724)",
              },
              layout = "dwindle",
              allow_tearing = true,
          },
          decoration = {
              rounding = 5,
              dim_inactive = false,
          },
          animations = {
              enabled = false,
          },
          binds = {
              allow_workspace_cycles = true,
          },
          dwindle = {
              preserve_split = true,
          },
          master = {
              new_status = "slave",
          },
           misc = {
               disable_hyprland_logo = true,
               disable_splash_rendering = false,
               col = {
                   splash = "rgb(c4a7e7)",
               },
               focus_on_activate = true,
           }
       })
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

  mkMakoConfig =
    scheme: font:
    with scheme.colors;
    pkgs.writeText "mako.ini" ''
      text-color=#${base05}
      border-color=#${base08}
      background-color=#${base00}

      anchor=top-right
      default-timeout=5000
      width=420
      outer-margin=20
      padding=10,15
      border-size=2
      max-icon-size=32
      font=${font.name} 14px

      [app-name=Plexamp]
      invisible=1

      [app-name=Thunderbird]
      invisible=1

      [mode=do-not-disturb]
      invisible=true

      [mode=do-not-disturb app-name=notify-send]
      invisible=false

      [urgency=critical]
      default-timeout=0
      layer=overlay
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
        cat << EOF > ''$out/bin/rofi-bluetooth
          #!/usr/bin/env bash
          if [ "\$ROFI_RETV" = "0" ]; then
            bluetoothctl devices | sed 's/^Device //'
            exit 0
          fi

          dev="\$1"
          [ -z "\$dev" ] && exit 0
          mac="''${dev%% *}"
          bluetoothctl info "\$mac" | grep -q "Connected: yes" \
            && bluetoothctl disconnect "\$mac" \
            || bluetoothctl connect "\$mac"
        EOF
        chmod +x ''$out/bin/rofi-bluetooth

        cat << EOF > ''$out/bin/rofi-launcher
          #!/usr/bin/env bash
          bluetoothctl power on
          theme="''$out/files/launchers/type-6/style-3.rasi"

          modi="drun,Bluetooth:''$out/bin/rofi-bluetooth,ssh,Theme:rofi-theme-mode"
          rofi -show drun -modi "\$modi" -p "Rofi" -theme "\$theme" \
            -terminal "wezterm" \
            -ssh-command '{terminal} start -- {ssh-client} {host}'
        EOF
        chmod +x ''$out/bin/rofi-launcher
      '';
    });

  mkTheme =
    config: wall: scheme: font:
    let
      hyprlandConfig = mkHyprlandConfig config scheme.slug;
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
        ln -sfn ${hyprlandConfig} $out/hypr/hyprland.lua

        cat << EOF > $out/waybar/config.css
          @define-color foreground #${scheme.colors.foreground};
          @define-color accent #${scheme.colors.base08};
          @define-color highlight #${scheme.colors.base0D};
          @define-color surface #${scheme.colors.base00};
          @define-color surface-alt #${scheme.colors.base01};
          @define-color muted #${scheme.colors.base04};
          @define-color warning #${scheme.colors.base09};
        EOF

        ln -sfn ${../dotfiles/waybar/config} $out/waybar/config
        ln -sfn ${../dotfiles/waybar/style.css} $out/waybar/style.css
        ln -sfn ${mkMakoConfig scheme font} $out/mako/mako.ini
        ln -sfn ${mkWeztermConfig scheme font} $out/wezterm/wezterm.lua
        ln -sfn ${gtkThemeFromScheme scheme} $out/gtk
      '';
    };

in
{
  inherit
    themeNames
    themeLabels
    schemes
    mkNextWallpaper
    mkSetTheme
    mkRofiThemeSelector
    mkHyprpaper
    mkLockscreen
    mkHyprlandConfig
    mkWeztermConfig
    mkRofiTheme
    mkTheme
    ;
}
