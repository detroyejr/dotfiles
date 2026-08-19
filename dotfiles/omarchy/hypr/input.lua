hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
o.exec_on_start("hyprctl setcursor Bibata-Modern-Ice 14")

hl.config({
  input =  {
    touchpad = {
      natural_scroll = true
    }
  }
})

hl.device({
  name = "steelseries-steelseries-sensei-310-esports-mouse",
  sensitivity = -0.5,
})
