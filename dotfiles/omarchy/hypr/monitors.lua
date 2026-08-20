-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

hl.monitor({ output = "desc:Dell Inc. DELL S2721QS BVR9513", mode = "2560x1440@59.95Hz", position = "auto", scale = 1.5 })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.5 })
