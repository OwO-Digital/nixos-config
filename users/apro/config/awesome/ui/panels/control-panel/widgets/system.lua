local awful		= require("awful")
local beautiful	= require("beautiful")
local gears		= require("gears")
local helpers	= require("helpers")
local icons		= require("icons")
local wibox		= require("wibox")

local system = wibox.widget {
	{
		{
			helpers.prembox({
					{
						image = icons.wifi,
						forced_height = 40,
						widget = wibox.widget.imagebox
					},
					{
						text = "WiFi",
						halign = "center",
						valign = "center",
						widget = wibox.widget.textbox
					},
					layout = wibox.layout.align.horizontal
			}, nil, false, true, false, false, true, beautiful.bg),
			helpers.prembox({
					{
						image = icons.bluetooth,
						forced_height = 40,
						widget = wibox.widget.imagebox
					},
					{
						text = "Bluetooth",
						halign = "center",
						valign = "center",
						widget = wibox.widget.textbox
					},
					layout = wibox.layout.align.horizontal
			}, nil, false, false, false, false, false, beautiful.bg),
			helpers.prembox({
					{
						image = icons.eye_candy,
						forced_height = 40,
						widget = wibox.widget.imagebox
					},
					{
						text = "Eye Candy",
						halign = "center",
						valign = "center",
						widget = wibox.widget.textbox
					},
					layout = wibox.layout.align.horizontal
			}, nil, false, false, false, false, false, beautiful.bg),
			helpers.prembox({
					{
						image = icons.night_light,
						forced_height = 40,
						widget = wibox.widget.imagebox
					},
					{
						text = "Night Light",
						halign = "center",
						valign = "center",
						widget = wibox.widget.textbox
					},
					layout = wibox.layout.align.horizontal
			}, nil, false, false, true, true, false, beautiful.bg),
			layout = wibox.layout.flex.horizontal
		},
		margins = 8,
		widget = wibox.container.margin
	},
	{
		{
			bar_shape = gears.shape.rounded_rect,
			bar_height = 8,
			bar_color = beautiful.lbg,
			bar_active_color = beautiful.barbtns,
			handle_color = beautiful.barbtns,
			handle_shape = gears.shape.circle,
			handle_width = 8,
			handle_cursor = "sb_h_double_arrow",
			maximum = 100,
			minimum = 0,
			forced_height = 32,
			widget = wibox.widget.slider
		},
		margins = 8,
		widget = wibox.container.margin
	},
	{
		{
			bar_shape = gears.shape.rounded_rect,
			bar_height = 8,
			bar_color = beautiful.lbg,
			bar_active_color = beautiful.barbtns,
			handle_color = beautiful.barbtns,
			handle_shape = gears.shape.circle,
			handle_width = 8,
			handle_cursor = "sb_h_double_arrow",
			maximum = io.popen('brightnessctl m'):read('*all'),
			minimum = 0,
			forced_height = 32,
			widget = wibox.widget.slider
		},
		margins = 8,
		widget = wibox.container.margin
	},
	layout = wibox.layout.fixed.vertical
}

return helpers.embox(system, nil, 8, false)
