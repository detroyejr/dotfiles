{
  pkgs,
  lib,
  ...
}:

let
  mkHyprlandConfig =
    config:
    pkgs.writeText "hyprland.lua" ''
      local terminal = "foot"
      local file_browser = "nautilus"
      local mainMod = "SUPER"

      hl.env("TERMINAL", terminal)

      hl.monitor({
        output = "eDP-1",
        mode = "preferred",
        position = "auto",
        scale = 2,
      })

      hl.monitor({
        output = "HDMI-A-1",
        mode = "2560x1440@59.95Hz",
        scale = 1.33,
      })
      if "${config.system.name}" == "pelican" then
        hl.monitor({
          output = "eDP-1",
          mode = "preferred",
          position = "auto",
          scale = 1.67,
        })
      end

      hl.device({
        name = "steelseries-steelseries-sensei-310-esports-mouse",
        sensitivity = -0.7,
      })

      ${lib.optionalString config.services.openrgb.enable ''hl.exec_cmd("openrgb-theme-sync")''}

      local windowRules = {
        {
          name = "omarchy-screensaver",
          match = { class = "org.omarchy.screensaver" },
          fullscreen = true,
        },
        {
          name = "keepass-float",
          match = { title = ".*KeePass$" },
          float = true,
          center = true,
        },
        {
          name = "nautilus-float",
          match = { class = "org.gnome.Nautilus" },
          float = true,
          center = true,
          size = "1100 700",
        },
        {
          name = "plexamp-float",
          match = { title = "^(Plexamp)$" },
          float = true,
          move = "100%-488 6%",
          size = "400 560",
          animation = "slide",
        },
      }

      for _, rule in ipairs(windowRules) do
        hl.window_rule(rule)
      end

      local bindings = {
        -- Window and layout controls
        {
          key = mainMod .. " + F",
          action = function()
            hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
            local monitor = hl.get_active_monitor()
            if monitor then
              local width = math.floor((monitor.width / monitor.scale) * 0.75)
              local height = math.floor((monitor.height / monitor.scale) * 0.85)
              hl.dispatch(hl.dsp.window.resize({ x = width, y = height }))
            end
            hl.dispatch(hl.dsp.window.center())
          end,
          options = { description = "Toggle floating window" },
        },
        {
          key = "SUPER + space",
          action = function()
            local window = hl.get_active_window()
            if not window then
              return
            end
            hl.dispatch(hl.dsp.window.cycle_next({
              floating = not window.floating,
              tiled = window.floating,
            }))
          end,
          options = {
            description = "Switch focus between tiled and floating windows",
          },
        },
        {
          key = mainMod .. " + SHIFT + L",
          action = function()
            local layout = hl.get_config("general.layout")
            hl.config({ general = { layout = layout == "scrolling" and "dwindle" or "scrolling" } })
          end,
          options = { description = "Toggle scrolling layout" },
        },
        {
          key = "CTRL + ALT + Delete",
          action = hl.dsp.exit(),
          options = { description = "Exit Hyprland" },
        },

        -- Media and brightness
        {
          key = "XF86AudioLowerVolume",
          action = hl.dsp.exec_cmd("pamixer --decrease 10"),
          options = {
            locked = true,
            repeating = true,
            description = "Decrease volume",
          },
        },
        {
          key = "XF86AudioMute",
          action = hl.dsp.exec_cmd("pamixer --toggle-mute"),
          options = {
            locked = true,
            repeating = true,
            description = "Toggle mute",
          },
        },
        {
          key = "XF86AudioNext",
          action = hl.dsp.exec_cmd("playerctl next"),
          options = { locked = true, description = "Play next track" },
        },
        {
          key = "XF86AudioPause",
          action = hl.dsp.exec_cmd("playerctl pause"),
          options = { locked = true, description = "Pause media playback" },
        },
        {
          key = "XF86AudioPlay",
          action = hl.dsp.exec_cmd("playerctl play-pause"),
          options = { locked = true, description = "Toggle media playback" },
        },
        {
          key = "XF86AudioPrev",
          action = hl.dsp.exec_cmd("playerctl previous"),
          options = { locked = true, description = "Play previous track" },
        },
        {
          key = "XF86AudioRaiseVolume",
          action = hl.dsp.exec_cmd("pamixer --increase 10 --set-limit 100"),
          options = {
            locked = true,
            repeating = true,
            description = "Increase volume",
          },
        },
        {
          key = "XF86AudioStop",
          action = hl.dsp.exec_cmd("playerctl stop"),
          options = { locked = true, description = "Stop media playback" },
        },
        {
          key = "XF86MonBrightnessDown",
          action = hl.dsp.exec_cmd("brightnessctl set '10%-'"),
          options = {
            locked = true,
            repeating = true,
            description = "Decrease screen brightness",
          },
        },
        {
          key = "XF86MonBrightnessUp",
          action = hl.dsp.exec_cmd("brightnessctl set '10%+'"),
          options = {
            locked = true,
            repeating = true,
            description = "Increase screen brightness",
          },
        },

        -- Move, resize, and focus windows
        {
          key = mainMod .. " + ALT + down",
          action = hl.dsp.window.move({ x = 0, y = 20 }),
          options = { repeating = true, description = "Move window down" },
        },
        {
          key = mainMod .. " + ALT + left",
          action = hl.dsp.window.move({ x = -20, y = 0 }),
          options = { repeating = true, description = "Move window left" },
        },
        {
          key = mainMod .. " + ALT + right",
          action = hl.dsp.window.move({ x = 20, y = 0 }),
          options = { repeating = true, description = "Move window right" },
        },
        {
          key = mainMod .. " + ALT + up",
          action = hl.dsp.window.move({ x = 0, y = -20 }),
          options = { repeating = true, description = "Move window up" },
        },
        {
          key = mainMod .. " + C",
          action = hl.dsp.window.close(),
          options = { description = "Close active window" },
        },
        {
          key = mainMod .. " + CTRL + P",
          action = hl.dsp.exec_cmd("hyprpicker | wl-copy"),
          options = { description = "Pick a color" },
        },
        {
          key = mainMod .. " + CTRL + down",
          action = hl.dsp.window.resize({ x = 0, y = 20 }),
          options = { repeating = true, description = "Grow window vertically" },
        },
        {
          key = mainMod .. " + CTRL + h",
          action = hl.dsp.focus({ direction = "left" }),
          options = { description = "Focus window to the left" },
        },
        {
          key = mainMod .. " + CTRL + j",
          action = hl.dsp.focus({ direction = "down" }),
          options = { description = "Focus window below" },
        },
        {
          key = mainMod .. " + CTRL + k",
          action = hl.dsp.focus({ direction = "up" }),
          options = { description = "Focus window above" },
        },
        {
          key = mainMod .. " + CTRL + l",
          action = hl.dsp.focus({ direction = "right" }),
          options = { description = "Focus window to the right" },
        },
        {
          key = mainMod .. " + CTRL + left",
          action = hl.dsp.window.resize({ x = -20, y = 0 }),
          options = { repeating = true, description = "Shrink window horizontally" },
        },
        {
          key = mainMod .. " + CTRL + right",
          action = hl.dsp.window.resize({ x = 20, y = 0 }),
          options = { repeating = true, description = "Grow window horizontally" },
        },
        {
          key = mainMod .. " + CTRL + up",
          action = hl.dsp.window.resize({ x = 0, y = -20 }),
          options = { repeating = true, description = "Shrink window vertically" },
        },

        -- Applications and utilities
        {
          key = mainMod .. " + E",
          action = hl.dsp.exec_cmd(file_browser),
          options = { description = "Open file browser" },
        },
        {
          key = mainMod .. " + G",
          action = hl.dsp.window.fullscreen(),
          options = { description = "Toggle fullscreen" },
        },
        {
          key = mainMod .. " + J",
          action = hl.dsp.layout("togglesplit"),
          options = { description = "Toggle window split" },
        },
        {
          key = mainMod .. " + L",
          action = hl.dsp.exec_cmd("bash -c \"hyprlock\""),
          options = { description = "Lock screen" },
        },
        {
          key = mainMod .. " + L",
          action = hl.dsp.exec_cmd("bash -c \"omarchy system lock\""),
          options = { description = "Lock screen" },
        },
        {
          key = mainMod .. " + M",
          action = hl.dsp.exec_cmd("$HOME/.local/bin/bash/minimize"),
          options = { description = "Minimize active window" },
        },
        {
          key = mainMod .. " + P",
          action = hl.dsp.window.pseudo(),
          options = { description = "Toggle pseudo-tiling" },
        },
        {
          key = mainMod .. " + PRINT",
          action = hl.dsp.exec_cmd("grim"),
          options = { description = "Capture screenshot" },
        },
        {
          key = mainMod .. " + Q",
          action = hl.dsp.exec_cmd(terminal),
          options = { description = "Open terminal" },
        },
        {
          key = mainMod .. " + R",
          action = hl.dsp.exec_cmd(
            "if pgrep -x rofi > /dev/null; then kill $(pgrep -x rofi); else $THEME/rofi/bin/rofi-launcher; fi"
          ),
          options = { description = "Open application launcher" },
        },
        {
          key = mainMod .. " + R",
          action = hl.dsp.exec_cmd("omarchy menu"),
          options = { description = "Open Omarchy menu" },
        },
        {
          key = mainMod .. " + SHIFT + E",
          action = hl.dsp.exec_cmd(
            "bash -c \"if pgrep -x wofi-emoji > /dev/null; then pkill wofi-emoji; else wofi-emoji; fi\""
          ),
          options = { description = "Toggle emoji picker" },
        },
        {
          key = mainMod .. " + SHIFT + J",
          action = hl.dsp.exec_cmd(
            "bash -c \"if pgrep -x @obsidian > /dev/null; then pkill obsidian; else obsidian; fi\""
          ),
          options = { description = "Toggle Obsidian" },
        },
        {
          key = mainMod .. " + SHIFT + K",
          action = hl.dsp.exec_cmd(
            "bash -c \"if pgrep -x mono > /dev/null; then pkill mono; else keepass; fi\""
          ),
          options = { description = "Toggle KeePass" },
        },
        {
          key = mainMod .. " + SHIFT + PRINT",
          action = hl.dsp.exec_cmd("grim -g \"$(slurp)\""),
          options = { description = "Capture selected area" },
        },
        {
          key = mainMod .. " + SHIFT + T",
          action = hl.dsp.exec_cmd("omarchy theme bg set \"$(omarchy theme bg switcher)\""),
          options = { description = "Change wallpaper" },
        },

        -- Directional and mouse bindings
        {
          key = mainMod .. " + down",
          action = hl.dsp.focus({ direction = "down" }),
          options = { description = "Focus window below" },
        },
        {
          key = mainMod .. " + left",
          action = hl.dsp.focus({ direction = "left" }),
          options = { description = "Focus window to the left" },
        },
        {
          key = mainMod .. " + mouse:272",
          action = hl.dsp.window.drag(),
          options = { mouse = true, description = "Drag window" },
        },
        {
          key = mainMod .. " + mouse:273",
          action = hl.dsp.window.resize(),
          options = { mouse = true, description = "Resize window with mouse" },
        },
        {
          key = mainMod .. " + mouse_down",
          action = hl.dsp.focus({ workspace = "e+1" }),
          options = { description = "Switch to next workspace" },
        },
        {
          key = mainMod .. " + mouse_up",
          action = hl.dsp.focus({ workspace = "e-1" }),
          options = { description = "Switch to previous workspace" },
        },
        {
          key = mainMod .. " + right",
          action = hl.dsp.focus({ direction = "right" }),
          options = { description = "Focus window to the right" },
        },
        {
          key = mainMod .. " + up",
          action = hl.dsp.focus({ direction = "up" }),
          options = { description = "Focus window above" },
        },
      }

      -- Workspace bindings
      for i = 1, 10 do
        local key = i % 10
        bindings[#bindings + 1] = {
          key = mainMod .. " + " .. key,
          action = hl.dsp.focus({ workspace = i }),
          options = { description = "Focus workspace " .. i },
        }
        bindings[#bindings + 1] = {
          key = mainMod .. " + SHIFT + " .. key,
          action = hl.dsp.window.move({ workspace = i }),
          options = { description = "Move window to workspace " .. i },
        }
      end

      for _, binding in ipairs(bindings) do
        hl.bind(binding.key, binding.action, binding.options)
      end

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
            drag_lock = ${if config.services.libinput.touchpad.tappingDragLock then "true" else "false"},
          },
        },
        general = {
          gaps_in = 2,
          gaps_out = 7,
          border_size = 0,
          layout = "dwindle",
          allow_tearing = false,
        },
        decoration = {
          rounding = 0,
          dim_inactive = false,
          blur = {
            enabled = false
          },
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
      })

      hl.on("hyprland.start", function()
        hl.exec_cmd("omarchy launch shell")
        hl.exec_cmd(terminal)
        hl.exec_cmd("hyprctl dispatch dpms on")
        hl.exec_cmd("firefox", { workspace = "2 silent" })
        hl.exec_cmd("obsidian", { workspace = "3 silent" })
        hl.exec_cmd("omarchy system lock")
      end)
    '';

  mkQuickShellTheme = pkgs.writeText "shell.toml" ''
    [bar]
    background-alpha = 1.0
    scale-with-font  = true
    size-horizontal  = 30
    size-vertical    = 28

    [font]
    base-size = 16
  '';
in
{
  inherit
    mkHyprlandConfig
    mkQuickShellTheme
    ;
}
