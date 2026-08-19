hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
o.exec_on_start("hyprctl setcursor Bibata-Modern-Ice 14")

hl.config({
  input =  {
    sensitivity = -0.5,
    touchpad = {
      natural_scroll = true
    }
  }
})
