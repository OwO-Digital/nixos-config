---------------------------------------------------------
--     WARN: this file is not meant to be touched.     --
-- Ignore this file unless you know what you're doing. --
---------------------------------------------------------

local gcr   = require("gears.color").recolor_image
local cmb   = require("helpers").combine
local color = require("modules.color")
local icons = require("icons")
local cols  = require("themes.cols." .. theme)
local recol = {}

local brighten = function(col) return (color.color { hex = col } + "0.1l").hex end

recol.layout_tile       = gcr(icons.tile,       cols.barbtns)
recol.layout_tilebottom = gcr(icons.tilebottom, cols.barbtns)
recol.layout_centered   = gcr(icons.centered,   cols.barbtns)
recol.layout_mstab      = gcr(icons.mstab,      cols.barbtns)
recol.layout_fairv      = gcr(icons.fairv,      cols.barbtns)
recol.layout_fairh      = gcr(icons.fairh,      cols.barbtns)
recol.layout_floating   = gcr(icons.floating,   cols.barbtns)
recol.layout_max        = cmb(icons.max1,       cols.barbtns,
                              icons.max2,       cols.green)

recol.titlebar_close_button_normal              = gcr(icons.btn,     cols.dfg)
recol.titlebar_close_button_focus               = gcr(icons.btn,     cols.red)
recol.titlebar_minimize_button_normal           = gcr(icons.btn,     cols.dfg)
recol.titlebar_minimize_button_focus            = gcr(icons.btn,     cols.yellow)
recol.titlebar_maximized_button_normal_inactive = gcr(icons.btn,     cols.dfg)
recol.titlebar_maximized_button_focus_inactive  = gcr(icons.btn,     cols.green)
recol.titlebar_maximized_button_focus_active    = cmb(icons.btn,     cols.green,
                                                      icons.maxicon, cols.bg)
recol.titlebar_maximized_button_normal_active   = cmb(icons.btn,     cols.green,
                                                      icons.maxicon, cols.bg)

recol.titlebar_close_button_focus_hover               = cmb(icons.btn, brighten(cols.red),    icons.closeicon, cols.bg)
recol.titlebar_close_button_normal_hover              = cmb(icons.btn, brighten(cols.red),    icons.closeicon, cols.bg)
recol.titlebar_minimize_button_focus_hover            = cmb(icons.btn, brighten(cols.yellow), icons.minicon,   cols.bg)
recol.titlebar_minimize_button_normal_hover           = cmb(icons.btn, brighten(cols.yellow), icons.minicon,   cols.bg)
recol.titlebar_maximized_button_focus_active_hover    = cmb(icons.btn, brighten(cols.green),  icons.maxicon,   cols.bg)
recol.titlebar_maximized_button_normal_active_hover   = cmb(icons.btn, brighten(cols.green),  icons.maxicon,   cols.bg)
recol.titlebar_maximized_button_focus_inactive_hover  = cmb(icons.btn, brighten(cols.green),  icons.maxicon,   cols.bg)
recol.titlebar_maximized_button_normal_inactive_hover = cmb(icons.btn, brighten(cols.green),  icons.maxicon,   cols.bg)

return recol
