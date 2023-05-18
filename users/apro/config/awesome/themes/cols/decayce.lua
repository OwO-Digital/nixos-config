local assets  = require('gears.filesystem').get_configuration_dir() .. "themes/assets/"
local cols = {}

	cols.black      = "#151720"
	cols.red        = "#dd6777"
	cols.green      = "#90ceaa"
	cols.yellow     = "#ecd3a0"
	cols.blue       = "#86aaec"
	cols.magenta    = "#c296eb"
	cols.cyan       = "#93cee9"
	cols.white      = "#cbced3"
								
	cols.bg         = "#0d0f18"
	cols.fg         = "#a5b6cf"
	cols.dbg        = "#0b0d16"
	cols.lbg        = "#11131c"
	cols.dfg        = "#7f848e"
	
	cols.alert      = cols.red
	
	cols.taglist    = cols.blue
	cols.barbtns    = cols.blue
	cols.clock      = cols.red
	cols.notifs     = cols.blue
	
	cols.border_normal = cols.lbg
	cols.border_focus  = cols.blue
	
	cols.launcher   = nil
	cols.pfpbg      = cols.dbg

return cols
