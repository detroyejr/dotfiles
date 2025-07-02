{ pkgs, config, ... }:

let
  weztermConfig =
    with config.colorScheme.colors;
    pkgs.writeText "wezterm.lua" ''
      local wezterm = require 'wezterm'

      config = {
        color_scheme = "custom",
        cursor_blink_rate = 0,
        font = wezterm.font("Input Mono"),
        font_size = 14,
        use_fancy_tab_bar = false,
        warn_about_missing_glyphs = false,
        window_background_opacity = 0.8,
        window_frame = {
            active_titlebar_bg = "${base03}",
            active_titlebar_fg = "${base05}",
            active_titlebar_border_bottom = "${base03}",
            border_left_color = "${base01}",
            border_right_color = "${base01}",
            border_bottom_color = "${base01}",
            border_top_color = "${base01}",
            button_bg = "${base01}",
            button_fg = "${base05}",
            button_hover_bg = "${base05}",
            button_hover_fg = "${base03}",
            inactive_titlebar_bg = "${base01}",
            inactive_titlebar_fg = "${base05}",
            inactive_titlebar_border_bottom = "${base03}",
        },
        command_palette_bg_color = "${base01}",
        command_palette_fg_color = "${base05}",
      }
      return config
    '';
  weztermColors =
    with config.colorScheme.colors;
    pkgs.writeText "custom.toml" ''
      [colors]
      ansi = [
          "${base00}",
          "${base08}",
          "${base0B}",
          "${base0A}",
          "${base0D}",
          "${base0E}",
          "${base0C}",
          "${base05}",
      ]
      background = "${base00}"
      brights = [
          "${base03}",
          "${base08}",
          "${base0B}",
          "${base0A}",
          "${base0D}",
          "${base0E}",
          "${base0C}",
          "${base07}",
      ]
      compose_cursor = "${base05}"
      cursor_bg = "${base05}"
      cursor_fg = "${base00}"
      foreground = "${base05}"
      scrollbar_thumb = "${base01}"
      selection_bg = "${base05}"
      selection_fg = "${base00}"
      split = "${base03}"
      visual_bell = "${base0E}"

      [colors.tab_bar]
      background = "${base01}"
      inactive_tab_edge = "${base01}"

      [colors.tab_bar.active_tab]
      bg_color = "${base00}"
      fg_color = "${base05}"

      [colors.tab_bar.inactive_tab]
      bg_color = "${base03}"
      fg_color = "${base05}"

      [colors.tab_bar.inactive_tab_hover]
      bg_color = "${base05}"
      fg_color = "${base00}"

      [colors.tab_bar.new_tab]
      bg_color = "${base03}"
      fg_color = "${base05}"

      [colors.tab_bar.new_tab_hover]
      bg_color = "${base05}"
      fg_color = "${base00}"

    '';
in
{
  users.users.detroyejr.packages = with pkgs; [ wezterm ];
  environment.etc = {
    "xdg/wezterm/wezterm.lua".source = weztermConfig;
    "xdg/wezterm/colors/custom.toml".source = weztermColors;
  };
}
