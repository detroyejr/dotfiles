{ pkgs, colorScheme, ... }:
{
  home.file.".config/nvim" = {
    source = ../../dotfiles/nvim;
    recursive = true;
  };

  home.file.".config/nvim/lua/user/colorscheme.lua".text = with colorScheme.colors; ''
    local Shade = require("nightfox.lib.shade")

    -- stylua: ignore
    local palettes = {
      nightfox = {
        black   = Shade.new("#${color0}", 0.15, -0.15),
        red     = Shade.new("#${color1}", 0.15, -0.15),
        green   = Shade.new("#${color2}", 0.10, -0.15),
        yellow  = Shade.new("#${color3}", 0.15, -0.15),
        blue    = Shade.new("#${color4}", 0.15, -0.15),
        magenta = Shade.new("#${color5}", 0.30, -0.15),
        cyan    = Shade.new("#${color6}", 0.15, -0.15),
        white   = Shade.new("#${color7}", 0.15, -0.15),
        orange  = Shade.new("#${color9}", 0.15, -0.15),
        pink    = Shade.new("#${color13}", 0.15, -0.15),

        bg0     = "#${color0}", -- Dark bg (status line and float)
        bg1     = "#${color0}", -- Default bg
        bg2     = "#${color8}", -- Lighter bg (colorcolm folds)
        bg3     = "#${color8}", -- Lighter bg (cursor line)
        bg4     = "#${color15}", -- Conceal, border fg

        fg0     = "#${color15}", -- Lighter fg
        fg1     = "#${color7}", -- Default fg
        fg2     = "#${color7}", -- Darker fg (status line)
        fg3     = "#${color7}", -- Darker fg (line numbers, fold colums)

        sel0    = "#${color8}", -- Popup bg, visual selection bg
        sel1    = "#${color8}", -- Popup sel bg, search bg

        comment = "#${color7}",
      }
    }

    -- Default options
    require('nightfox').setup({
      palettes = palettes
    })
  '';

  programs.neovim = {
    enable = true;
  };

  home.packages = with pkgs; [
    nixd
    stylua
  ];
}
