local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
local rubato = require("modules.rubato")
local color = require("modules.color")
local helpers = require("helpers")

local bar_dir, bar_h_rev, bar_w_rev
if bar_orientation == "vertical" then
	bar_dir = "east"
	bar_h_rev = { 0,   80  }
	bar_w_rev = { nil, nil }
elseif bar_orientation == "horizontal" then
	bar_dir = "south"
	bar_h_rev = { nil, nil }
	bar_w_rev = { 0,   80  }
end

return function(s)
	local volbar = wibox.widget {
		{
			{
				{
					{
						id               = "vol",
						widget           = wibox.widget.slider,
						bar_shape        = gears.shape.rounded_rect,
						bar_height       = 4,
						bar_color        = beautiful.lbg,
						bar_active_color = beautiful.barbtns,
						handle_color     = beautiful.barbtns,
						handle_shape     = gears.shape.circle,
						handle_width     = 4,
						handle_cursor    = "sb_v_double_arrow",
						maximum          = 100,
						minimum          = 0,
						forced_width     = 80,
					},
					id        = "rotate",
					widget    = wibox.container.rotate,
					direction = bar_dir
				},
				id      = "margin",
				widget  = wibox.container.margin,
				margins = 8,
			},
			id       = "reveal",
			widget   = wibox.container.constraint,
			strategy = "max",
			width    = bar_w_rev[1],
			height   = bar_h_rev[1],
		},
		{
			{
				{
						widget = wibox.widget.textbox,
						markup = "<span foreground='" .. beautiful.barbtns .. "'></span>",
						align  = "center",
						valign = "center",
						font = helpers.join({beautiful.icfontsp, beautiful.fontsize * 1.4}),
						forced_width  = 28,
						forced_height = 28,
						id = "icon"
					},
				widget = wibox.container.background,
				id     = "bgcol"
			},
			widget = wibox.container.background,
			shape  = helpers.rrect(4),
			id     = "shape"
		},
		layout = wibox.layout.fixed[bar_orientation]
	}

	local icon = volbar.shape.bgcol.icon
	local vol = volbar.reveal.margin.rotate.vol

	local update_icon = function()
		if vol:get_bar_active_color() ~= beautiful.dfg then
  	    	awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
  	     	 	if tonumber(stdout) > 50 then
  	    		    icon:set_markup("<span foreground='" .. beautiful.barbtns .. "'>󰕾</span>")
  	    		elseif 50 >= tonumber(stdout) and tonumber(stdout) > 0 then
  	    		    icon:set_markup("<span foreground='" .. beautiful.barbtns .. "'>󰖀</span>")
  	    		elseif tonumber(stdout) == 0 then
  	    		    icon:set_markup("<span foreground='" .. beautiful.barbtns .. "'>󰕿</span>")
  	    		end
			end)
		end
	end

	local update_mute = function()
		awful.spawn.easy_async_with_shell("pamixer --get-mute", function(stdout)
			if stdout:gsub("\n", "") == "true" then
				icon:set_markup("<span foreground='" .. beautiful.dfg .. "'>󰝟</span>")
			
				vol:set_bar_active_color(beautiful.dfg)
  	        		vol:set_handle_color    (beautiful.dfg)
			else
				vol:set_bar_active_color(beautiful.barbtns)
				vol:set_handle_color    (beautiful.barbtns)
				update_icon()
			end
		end)
	end

	volbar:buttons(gears.table.join(
		awful.button({ }, 4, function() vol:set_value(vol.value+5) end),
		awful.button({ }, 5, function() vol:set_value(vol.value-5) end))
	)

	volbar.shape:buttons(gears.table.join(
		awful.button({ }, 1, function()
			awful.spawn.with_shell("pamixer -t")
			update_mute()
		end),
		awful.button({ }, 3, function() awful.spawn.with_shell(terminal .. " -e pulsemixer") end)
	))

	local volume_slide
	if bar_orientation == "vertical" then
	volume_slide = rubato.timed {
		pos        = 0,
		duration   = 0.5,
		intro      = 0,
		outro      = 0.4,
		easing     = rubato.quadratic,
		subscribed = function(pos) volbar.reveal:set_height(pos) end
	} elseif bar_orientation == "horizontal" then
	volume_slide = rubato.timed {
		pos        = 0,
		duration   = 0.5,
		intro      = 0,
		outro      = 0.4,
		easing     = rubato.quadratic,
		subscribed = function(pos) volbar.reveal:set_width(pos) end
	} end


	volbar:connect_signal("mouse::enter", function()
		awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
			vol:set_value(tonumber(stdout))
		end)
		update_icon()
		volume_slide.target = 80
	end)

	volbar:connect_signal("mouse::leave", function()
		volume_slide.target = 0
	end)

	local dbg = color.color { hex = beautiful.dbg }
	local lbg = color.color { hex = beautiful.lbg }

	local btntrans = color.transition(dbg, lbg)
	local btnanim = rubato.timed {
		duration = 0.2,
		intro    = 0.1,
		subscribed = function(pos) volbar.shape.bgcol.bg = btntrans(pos).hex end
	}

	volbar.shape:connect_signal("mouse::enter", function()
		btnanim.target = 1
	local w = mouse.current_wibox
	if w then
			old_cursor, old_wibox = w.cursor, w
			w.cursor = "hand1"
	end
	end)

	volbar.shape:connect_signal("mouse::leave", function()
		btnanim.target = 0
	if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
	end
	end)

	vol:connect_signal("mouse::press", function()
	local w = mouse.current_wibox
	if w then
		old_cursor, old_wibox = w.cursor, w
		w.cursor = "sb_double_arrow"
	end
   end)

	vol:connect_signal("mouse::release", function()
	if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
	end
	end)

	vol:connect_signal("property::value", function()
		awful.spawn.with_shell("pamixer --set-volume " .. vol:get_value())
		update_icon()
	end)

	awesome.connect_signal("optimize::toggle", function(optimized)
		btnanim.duration      = (optimized and 0.01 or 0.2)
		volume_slide.duration = (optimized and 0.01 or 0.5)
	end)

	update_icon()
	update_mute()
	return helpers.embox(volbar, false, 0, false, false)
end
