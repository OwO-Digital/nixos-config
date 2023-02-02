local cols = require("themes.cols." .. theme)
local dpi  = require("beautiful.xresources").apply_dpi
local join = require("helpers").join
local vars = {}

vars.mnfontsp = "Iosevka Nerd Font Mono"
vars.uifontsp = "Roboto Condensed, "
vars.icfontsp = "Material Design Icons"

vars.fontsize = dpi(11)

vars.nocap = { "mpd" } -- no cap frfr on god 🚫 🧢 🙏

vars.font = join({vars.mnfontsp, vars.fontsize})

vars.playerctl_ignore = { "firefox" }
vars.playerctl_player = { "mpd", "spotify", "%any" }

vars.useless_gap = 8
vars.border_radius = 6
vars.border_size = 2
vars.btnsize = 16
vars.iconsize = 20
vars.systray_icon_spacing = 4

return vars
