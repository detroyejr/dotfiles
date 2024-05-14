{ colorScheme, wallpaper, ... }:
{
  programs.hyprlock = with colorScheme.colors;
    let
      text_color = "rgba(${base04}FF)";
      entry_background_color = "rgba(${base02}FF)";
      entry_border_color = "rgba(${base09}FF)";
      entry_color = "rgba(${base04}FF)";
    in
    {
      enable = true;
      settings = {
        backgrounds = [
          {
            monitor = "";
            path = "${builtins.toString wallpaper}";
            blur_passes = 1; # 0 disables blurring
            blur_size = 7;
          }
        ];
        images = [
          {
            monitor = "";
            path = builtins.toString ../../../assets/profile.png;
            position = { x = 0; y = 270; };
            halign = "center";
            valign = "center";
            size = 400;
            rounding = -2;
          }
        ];
        input-fields = [
          {
            monitor = "";
            outline_thickness = 2;
            size = { width = 350; height = 90; };
            dots_size = 0.3;
            dots_spacing = 0.4;
            outer_color = entry_border_color;
            inner_color = entry_background_color;
            font_color = entry_color;
            position = { x = 0; y = -130; };
            halign = "center";
            valign = "center";
          }
        ];
        labels = [
          {
            monitor = "";
            text = "$TIME";
            color = text_color;
            font_size = 65;
            font_family = "BlexMono Nerd Font";
            position = { x = 0; y = 550; };
          }
          {
            text = "Hi there, $USER";
            color = text_color;
            font_size = 35;
            position = { x = 0; y = 0; };
            font_family = "BlexMono Nerd Font";
          }
        ];
      };
    };
}
