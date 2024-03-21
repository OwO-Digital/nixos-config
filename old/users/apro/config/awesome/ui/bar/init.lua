local awful     = require("awful")
local beautiful = require("beautiful")
local gears	= require("gears")
local helpers   = require("helpers")
local wibox     = require("wibox")
require("conf.menu")
require("conf.keys")

bar_orientation = ""
if     bar_position == "top"  or bar_position == "bottom" then bar_orientation = "horizontal"
elseif bar_position == "left" or bar_position == "right"  then bar_orientation = "vertical"
end

local opposites = {
	left   = "right",
	right  = "left",

	up     = "down",
	down   = "up",

	top    = "bottom",
	bottom = "top",
}

awful.screen.connect_for_each_screen(function(s)

local bar_margins, bar_ishape, bar_oshape, bar_ssize, bar_lsize
if bar_floating == true then
	bar_margins = {
		left   = "left"   ~= opposites[bar_position] and beautiful.useless_gap or 0,
		right  = "right"  ~= opposites[bar_position] and beautiful.useless_gap or 0,
		top    = "top"    ~= opposites[bar_position] and beautiful.useless_gap or 0,
		bottom = "bottom" ~= opposites[bar_position] and beautiful.useless_gap or 0,
	}

	bar_ishape = helpers.rrect(beautiful.border_radius - beautiful.border_size or 0)
	bar_oshape = helpers.rrect(beautiful.border_radius)

	bar_realsize = bar_outline and bar_size + 2 * beautiful.border_size or bar_size
	bar_length   = (bar_orientation == "vertical" and s.geometry.height or bar_orientation == "horizontal" and s.geometry.width) - (2 * beautiful.useless_gap)
elseif bar_floating == false then
	bar_margins = nil

	bar_ishape = gears.shape.rectangle
	bar_oshape = gears.shape.rectangle

	bar_realsize = bar_outline and bar_size + 2 * beautiful.border_size or bar_size
	bar_length   = bar_orientation == "vertical" and s.geometry.height or bar_orientation == "horizontal" and s.geometry.width
end

	local barmenu = wibox.widget {
		awful.widget.launcher({ image = beautiful.launcher,
		                        menu = menu }),
		widget = wibox.container.margin,
		margins = 4 + beautiful.launcher_padding
	}
	local taglist = require("ui.bar.widgets.taglist")(s)
	local tasklist = require("ui.bar.widgets.tasklist")(s)
	local systray = require("ui.bar.widgets.systray")(s)
	local battery = nil; if laptop then battery = require("ui.bar.widgets.battery") end
	local volumebar = require("ui.bar.widgets.sliders.volume")(s)
	-- local kbdwidget = require("ui.bar.widgets.keyboard")
	local layouticon = helpers.embox(
		awful.widget.layoutbox {
			screen  = s,
			buttons = {
				awful.button({ }, 1, function () awful.layout.inc( 1) end),
				awful.button({ }, 3, function () awful.layout.inc(-1) end),
				awful.button({ }, 4, function () awful.layout.inc(-1) end),
				awful.button({ }, 5, function () awful.layout.inc( 1) end)
			},
		},
	false, 6, nil, false)

	if bar_orientation == "vertical" then
		clock_format =
			"<span foreground='" .. beautiful.white .. "'>%I</span>\n"..
			"<span foreground='" .. beautiful.white .. "'>%M</span>\n"..
			"<span foreground='" .. beautiful.clock .. "'>%p</span>"
	
	elseif bar_orientation == "horizontal" then
		clock_format = "<span foreground='" .. beautiful.white .. "'>%I:%M</span> " .. "<span foreground='" .. beautiful.clock .. "'>%p</span>"
	end
	
	local clock = helpers.embox(
		wibox.widget {
			refresh = 1,
			widget  = wibox.widget.textclock,
			align   = "center",
			valign  = "center",
			format  = clock_format,
		}
	)



	-- Create the wibox
	s.wibar = awful.wibar({
		bg = "#00000000",
		position = bar_position,
		screen = s,
		type = "dock",
		margins = bar_margins,
		width  = bar_orientation == "vertical" and bar_realsize or bar_orientation == "horizontal" and bar_length,
		height = bar_orientation == "vertical" and bar_length   or bar_orientation == "horizontal" and bar_realsize,
	})

	-- Add widgets to the wibox
	local placeholder = {
		{
			{ -- Top widgets
				barmenu,
				taglist,
				layout = wibox.layout.fixed[bar_orientation],
			},
			tasklist,
			{
				systray,
				battery,
				helpers.embox({
					layout = wibox.layout.fixed[bar_orientation],
					spacing = 2,
					volumebar,
					-- kbdwidget,
					layouticon
				}, nil, 0, false),
				clock,
				layout = wibox.layout.fixed[bar_orientation],
			},
			layout = wibox.layout.align[bar_orientation],
		},
		widget = wibox.container.background,
		shape  = bar_ishape,
		bg     = beautiful.bg,
	}



	local bar
	if bar_outline == true then
		bar = {
			{
				placeholder,
				widget  = wibox.container.margin,
				margins = beautiful.border_size,
			},
			widget = wibox.container.background,
			shape  = bar_oshape,
			bg     = beautiful.lbg,
		}
	elseif bar_outline == false then
		bar = placeholder
	end

	s.wibar:setup(bar)
end)
