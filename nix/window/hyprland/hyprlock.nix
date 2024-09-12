{ colorScheme, wallpaper, ... }:
{
  programs.hyprlock =
    with colorScheme.colors;
    let
      text_color = "rgba(${base04}FF)";
      entry_background_color = "rgba(${base02}FF)";
      entry_border_color = "rgba(${base09}FF)";
      entry_color = "rgba(${base04}FF)";
    in
    {
      enable = true;
      settings = {
        background = [
          {
            monitor = "";
            path = "${builtins.toString wallpaper}";
            blur_passes = 1; # 0 disables blurring
            blur_size = 7;
          }
        ];
        image = [
          {
            monitor = "";
            path = builtins.toString ../../../assets/profile.png;
            position = "0, 270";
            halign = "center";
            valign = "center";
            size = 400;
            rounding = -2;
          }
        ];
        input-field = [
          {
            monitor = "";
            outline_thickness = 2;
            size = "350, 90";
            dots_size = 0.3;
            dots_spacing = 0.4;
            outer_color = entry_border_color;
            inner_color = entry_background_color;
            font_color = entry_color;
            position = "0, -130";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            monitor = "";
            text = "$TIME";
            text_align = "center";
            color = text_color;
            font_size = 65;
            font_family = "BlexMono Nerd Font";
            rotate = 0;
            position = "0, 550";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "Hi there, $USER";
            text_align = "center";
            color = text_color;
            font_size = 35;
            font_family = "BlexMono Nerd Font";
            rotate = 0;
            position = "0, 0";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
}
