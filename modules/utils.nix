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

       hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2 })

       -- ODP 
       hl.monitor({ output = "HDMI-A-1", mode="2560x1440@59.95Hz", scale = 1.33 })

       if "${config.system.name}" == "pelican" then
         hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.2 })
       end

       hl.env("TERMINAL", terminal)

       ${lib.optionalString config.services.openrgb.enable ''hl.exec_cmd("openrgb-theme-sync")''}

       -- Default animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
       hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
       hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
       hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
       hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
       hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

       hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
       hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
       hl.animation({ leaf = "windows", enabled = true, speed = 3.79, bezier = "easeOutQuint" })
       hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
       hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
       hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
       hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
       hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
       hl.animation({ leaf = "fadeSwitch", enabled = false })
       hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
       hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
       hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
       hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
       hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
       hl.animation({ leaf = "workspaces", enabled = false })
       hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })

       hl.on("hyprland.start", function () 
         hl.exec_cmd(terminal)
         hl.exec_cmd("hyprctl dispatch dpms on")

         hl.exec_cmd("omarchy launch shell")
         hl.exec_cmd("omarchy system lock")
         hl.exec_cmd("firefox", { workspace = "2 silent" })
         hl.exec_cmd("obsidian", { workspace = "3 silent" })
         hl.exec_cmd("keepass $HOME/Documents/Sync/Personal_KeyPass.kdbx", { workspace = "9 silent" })
       end)

       hl.device({
         name = "steelseries-steelseries-sensei-310-esports-mouse",
         sensitivity = -0.7,
       })


       hl.window_rule({
         name = "omarchy-screensaver",
         match = { class = "org.omarchy.screensaver" },
         fullscreen = true,
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
         name = "nautilus-float",
         match = { class = "org.gnome.Nautilus" },
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

       -- Move active window to a workspace with mainMod + SHIFT + [0-9]
       for i = 1, 10 do
           local key = i % 10
           hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}), { description = "Focus workspace " .. i })
           hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
       end

       hl.bind(mainMod .. " + F", function()
         hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
         hl.dispatch(hl.dsp.window.center())
         hl.dispatch(hl.dsp.window.resize({ x = 1300, y = 850 }))
       end, { description = "Toggle floating window" })

       hl.bind(mainMod .. " + SHIFT + L", function()
         local layout = hl.get_config("general.layout")
         hl.config({ general = { layout = layout == "scrolling" and "dwindle" or "scrolling" } })
       end, { description = "Toggle scrolling layout" })

       hl.bind("CTRL + ALT + Delete", hl.dsp.exit(), { description = "Exit Hyprland" })
       hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer --decrease 10"), { locked = true, repeating = true, description = "Decrease volume" })
       hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer --toggle-mute"), { locked = true, repeating = true, description = "Toggle mute" })
       hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Play next track" })
       hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true, description = "Pause media playback" })
       hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Toggle media playback" })
       hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Play previous track" })
       hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer --increase 10 --set-limit 100"), { locked = true, repeating = true, description = "Increase volume" })
       hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true, description = "Stop media playback" })
       hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set '10%-'"), { locked = true, repeating = true, description = "Decrease screen brightness" })
       hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set '10%+'"), { locked = true, repeating = true, description = "Increase screen brightness" })
       hl.bind(mainMod .. " + ALT + down", hl.dsp.window.move({ x = 0, y = 20 }), { repeating = true, description = "Move window down" })
       hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ x = -20, y = 0 }), { repeating = true, description = "Move window left" })
       hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ x = 20, y = 0 }), { repeating = true, description = "Move window right" })
       hl.bind(mainMod .. " + ALT + up", hl.dsp.window.move({ x = 0, y = -20 }), { repeating = true, description = "Move window up" })
       hl.bind(mainMod .. " + C", hl.dsp.window.close(), { description = "Close active window" })
       hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("hyprpicker | wl-copy"), { description = "Pick a color" })
       hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20 }), { repeating = true, description = "Grow window vertically" })
       hl.bind(mainMod .. " + CTRL + h", hl.dsp.focus({ direction = "left" }), { description = "Focus window to the left" })
       hl.bind(mainMod .. " + CTRL + j", hl.dsp.focus({ direction = "down" }), { description = "Focus window below" })
       hl.bind(mainMod .. " + CTRL + k", hl.dsp.focus({ direction = "up" }), { description = "Focus window above" })
       hl.bind(mainMod .. " + CTRL + l", hl.dsp.focus({ direction = "right" }), { description = "Focus window to the right" })
       hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0 }), { repeating = true, description = "Shrink window horizontally" })
       hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0 }), { repeating = true, description = "Grow window horizontally" })
       hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20 }), { repeating = true, description = "Shrink window vertically" })
       hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file_browser), { description = "Open file browser" })
       hl.bind(mainMod .. " + G", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })
       hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle window split" })
       hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("bash -c \"hyprlock\""), { description = "Lock screen" })
       hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("bash -c \"omarchy system lock\""), { description = "Lock screen" })
       hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("$HOME/.local/bin/bash/minimize"), { description = "Minimize active window" })
       hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Toggle pseudo-tiling" })
       hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("grim"), { description = "Capture screenshot" })
       hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal), { description = "Open terminal" })
       hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("if pgrep -x rofi > /dev/null; then kill $(pgrep -x rofi); else $THEME/rofi/bin/rofi-launcher; fi"), { description = "Open application launcher" })
       hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("omarchy menu"), { description = "Open Omarchy menu" })
       hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("bash -c \"if pgrep -x wofi-emoji > /dev/null; then pkill wofi-emoji; else wofi-emoji; fi\""), { description = "Toggle emoji picker" })
       hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("bash -c \"if pgrep -x @obsidian > /dev/null; then pkill obsidian; else obsidian; fi\""), { description = "Toggle Obsidian" })
       hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("bash -c \"if pgrep -x mono > /dev/null; then pkill mono; else keepass; fi\""), { description = "Toggle KeePass" })
       hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("grim -g \"$(slurp)\""), { description = "Capture selected area" })
       hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("omarchy theme bg set \"$(omarchy theme bg switcher)\""), { description = "Change wallpaper" })
       hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Focus window below" })
       hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Focus window to the left" })
       hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
       hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with mouse" })
       hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Switch to next workspace" })
       hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Switch to previous workspace" })
       hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Focus window to the right" })
       hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Focus window above" })

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
             rounding = 0,
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
