local gfs  = require("gears.filesystem")
local cols = require("themes.cols." .. theme)
local vars = require("themes.vars")
local theming = {}

theming.bg_normal     = cols.bg
theming.bg_focus      = cols.lbg
theming.bg_urgent     = cols.alert
theming.bg_minimize   = cols.dbg

theming.fg_normal     = cols.fg
theming.fg_focus      = cols.fg
theming.fg_urgent     = cols.fg
theming.fg_minimize   = cols.fg

theming.taglist_bg_focus    = cols.taglist
theming.taglist_fg_occupied = cols.taglist
theming.taglist_fg_empty    = cols.dfg
theming.taglist_fg_focus    = cols.bg

theming.bg_systray = cols.dbg

theming.tabbar_disable = true
theming.mstab_bar_padding = vars.useless_gap
theming.mstab_border_radius = vars.border_radius
theming.mstab_tabbar_style = "boxes"

theming.border_width = 0
theming.menu_height  = 20
theming.menu_width   = 150
theming.icon_theme   = "Papirus"

if cols.launcher == nil then
	theming.launcher = require("icons").distro
	theming.launcher_padding = 2
else
	theming.launcher_padding = 0
end

require("awful").spawn("feh --bg-fill -z " .. (gfs.get_configuration_dir() .. "themes/assets/walls/".. theme))

return theming

