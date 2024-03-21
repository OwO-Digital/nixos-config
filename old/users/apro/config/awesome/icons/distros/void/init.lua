local gfs  = require("gears.filesystem")
local dir  = gfs.get_configuration_dir() .. "icons/distros/"
local gcr  = require("gears.color").recolor_image
local cmb  = require("helpers").combine
local cols = require("themes.cols." .. theme)

return gcr(dir .. "void/void.svg", cols.green)
