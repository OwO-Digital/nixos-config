local assets  = require('gears.filesystem').get_configuration_dir() .. "themes/assets/"
local cols = {}

	cols.black      = "#0a1114"
	cols.red        = "#e57474"
	cols.green      = "#8ccf7e"
	cols.yellow     = "#e5c76b"
	cols.blue       = "#67b0e8"
	cols.magenta    = "#c47fd5"
	cols.cyan       = "#6cbfbf"
	cols.white      = "#dadada"
								
	cols.bg         = "#141b1e"
	cols.fg         = cols.white
	cols.dbg        = cols.black
	cols.lbg        = "#232a2d"
	cols.dfg        = "#404749"
	
	cols.alert      = cols.red
	
	cols.taglist    = cols.green
	cols.barbtns    = cols.magenta
	cols.clock      = cols.red
	cols.notifs     = cols.blue
	
	cols.border_normal = cols.lbg
	cols.border_focus  = cols.blue
	
	cols.launcher   = nil
	cols.pfpbg      = cols.dbg

return cols
