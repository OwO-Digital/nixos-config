local awful     = require("awful")
local beautiful = require("beautiful")
local gears		= require("gears")
local helpers   = require("helpers")
local wibox     = require("wibox")

s.control_panel = awful.popup {
	type = "dock",
	screen = s,
	bg = "#00000000",
	ontop = true,
	-- visible = false
	visible = true,
	maximum_width = 700,
	maximum_height = 700,
	placement = function(d)
		awful.placement.bottom_left(d, {
			honor_workarea = true,
			honor_padding = true,
			margins = beautiful.useless_gap,
		})
	end,

	widget = {
		{
			{
				wibox.widget.textbox("Control Panel"),
				widget = wibox.container.margin,
				margins = beautiful.border_size * 2,
			},
			widget = wibox.container.background,
			shape = helpers.prrect(beautiful.border_radius, true, true, false, false),
			bg = beautiful.lbg,
		},
		{
			{
				{
					{
						{
							require("ui.panels.control-panel.widgets.user"),
							require("ui.panels.control-panel.widgets.system"),
							spacing = beautiful.border_size,
							layout = wibox.layout.fixed.vertical
						},
						widget = wibox.container.margin,
						margins = beautiful.border_size,
					},
					widget = wibox.container.background,
					shape = helpers.rrect(beautiful.border_radius - beautiful.border_size or 0),
					bg = beautiful.bg,
				},
				widget = wibox.container.margin,
				margins = beautiful.border_size,
			},
			widget = wibox.container.background,
			shape = helpers.prrect(beautiful.border_radius, false, false, true, true),
			bg = beautiful.lbg,
		},
		widget = wibox.layout.fixed.vertical
	}
}

