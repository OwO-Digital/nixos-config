local gfs  = require("gears.filesystem")
local dir  = gfs.get_configuration_dir() .. "icons/distros/"
local gcr  = require("gears.color").recolor_image
local cmb  = require("helpers").combine
local cols = require("themes.cols." .. theme)

return cmb(dir .. "nixos/nixos1.svg", cols.blue,
					 dir .. "nixos/nixos2.svg", cols.cyan)
