local beautiful = require("beautiful")
local pretty = {}

local export = function(t)
    for k, v in pairs(t) do
        pretty[k] = v
    end
end

export(require("themes.cols."..theme))
export(require "themes.vars")
export(require "themes.recolor")
export(require "themes.misc")

beautiful.init(pretty)
