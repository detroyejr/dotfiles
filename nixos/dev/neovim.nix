{
  pkgs,
  colorScheme,
  colorSchemeName,
  ...
}:
let
  colors =
    with colorScheme.colors;
    pkgs.writeText "colorscheme.lua" ''
      local Shade = require("nightfox.lib.shade")

      COLORSCHEME = "${colorSchemeName}"

      -- stylua: ignore
      local palettes = {
        nightfox = {
          black   = Shade.new("#${base00}", 0.15, -0.15),
          red     = Shade.new("#${base08}", 0.15, -0.15),
          green   = Shade.new("#${base0B}", 0.10, -0.15),
          yellow  = Shade.new("#${base0A}", 0.15, -0.15),
          blue    = Shade.new("#${base0D}", 0.15, -0.15),
          magenta = Shade.new("#${base0E}", 0.30, -0.15),
          cyan    = Shade.new("#${base0C}", 0.15, -0.15),
          white   = Shade.new("#${base07}", 0.15, -0.15),
          orange  = Shade.new("#${base09}", 0.15, -0.15),
          pink    = Shade.new("#${base0F}", 0.15, -0.15),

          bg0     = "#${base01}", -- Dark bg (status line and float)
          bg1     = "#${base00}", -- Default bg
          bg2     = "#${base02}", -- Lighter bg (colorcolm folds)
          bg3     = "#${base03}", -- Lighter bg (cursor line)
          bg4     = "#${base04}", -- Conceal, border fg

          fg0     = "#${base07}", -- Lighter fg
          fg1     = "#${base06}", -- Default fg
          fg2     = "#${base05}", -- Darker fg (status line)
          fg3     = "#${base05}", -- Darker fg (line numbers, fold colums)

          sel0    = "#${base02}", -- Popup bg, visual selection bg
          sel1    = "#${base03}", -- Popup sel bg, search bg

          comment = "#${base04}",
        }
      }

      -- Default options
      require('nightfox').setup({
        palettes = palettes
      })
    '';
  neovim = pkgs.stdenv.mkDerivation {
    pname = "neovim-config";
    version = "1.0";
    src = ../../dotfiles/nvim;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin $out/share/nvim && cp -r . $out/share/nvim
      cp ${colors} $out/share/nvim/lua/config/colorscheme.lua
      makeWrapper ${pkgs.neovim}/bin/nvim $out/bin/nvim \
        --set XDG_CONFIG_HOME $out/share
    '';
  };
in
{
  users.users.detroyejr.packages = [
    neovim
  ];
}
