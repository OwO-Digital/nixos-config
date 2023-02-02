local assets  = require('gears.filesystem').get_configuration_dir() .. "themes/assets/"
local cols, more = {}, {}

    cols.black      = "#11111b"
    cols.red        = "#f38ba8"
    cols.green      = "#a6e3a1"
    cols.yellow     = "#f9e2af"
    cols.blue       = "#89dceb"
    cols.magenta    = "#f5c2e7"
    cols.cyan       = "#94e2d5"
    cols.white      = "#cdd6f4"
    more.lavender   = "#b4befe"
                                
    cols.bg         = "#1e1e2e"
    cols.fg         = cols.white
    cols.dbg        = cols.black
    cols.lbg        = "#313244"
    cols.dfg        = "#6c7086"
    
    cols.alert      = cols.red
    
    cols.taglist    = cols.magenta
    cols.barbtns    = cols.magenta
    cols.clock      = cols.red
    cols.notifs     = cols.magenta
    
    cols.border_normal  = cols.lbg
    cols.border_focus   = more.lavender
    
    cols.launcher   = assets .. "launchers/" .. theme .. ".png"
    cols.pfpbg      = cols.dbg

return cols
