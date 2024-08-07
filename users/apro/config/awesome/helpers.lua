local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local color     = require("modules.color")
local rubato    = require("modules.rubato")

local helpers   = {}

helpers.rrect = function(rad)
	return function(cr,w,h)
		gears.shape.rounded_rect(cr,w,h,rad)
	end
end

helpers.prrect = function(rad,tl,tr,br,bl)
	return function(cr,w,h)
		gears.shape.partially_rounded_rect(cr,w,h,tl,tr,br,bl,rad)
	end
end

helpers.contains = function(t, i)
	for _, v in pairs(t) do
		if v == i then
			return true
		end
	end
	return false
end

helpers.join = function(t, d)
	local d = d or " "
	local out
	for _, v in ipairs(t) do
		if not out then
			out = tostring(v)
		else
			out = out .. d .. tostring(v)
		end
	end
	return out
end

helpers.combine = function(img1,col1,img2,col2,w,h)
	local w = w or 64
	local h = h or 64
	return wibox.widget.draw_to_image_surface (wibox.widget {
		wibox.widget.imagebox(gears.color.recolor_image(img1,col1)),
		wibox.widget.imagebox(gears.color.recolor_image(img2,col2)),
		layout = wibox.layout.stack },
		w,h)
end

helpers.embox = function(w, plfix, padding, hover_effects, have_margin)
	local plfix = plfix or false
	local padding = padding or 2
	if plfix == true then
		w = wibox.widget {
			w,
			widget = wibox.container.place,
			halign = "center",
			valign = "center"
		}
	end

	local margin

	if have_margin ~= false then
		margin = 4
	end

	local boxed = wibox.widget
	{
		{
			{
				{
					w,
			 		widget  = wibox.container.margin,
					margins = padding
				},
				widget = wibox.container.background,
				bg     = beautiful.dbg,
				id     = "bgcol"
			},
			widget = wibox.container.background,
			shape  = helpers.rrect(4),
			id     = "shape"
		},
		widget  = wibox.container.margin,
		margins = margin
	}

	if hover_effects ~= false then
		local dbg = color.color { hex = beautiful.dbg }
		local lbg = color.color { hex = beautiful.lbg }

		local boxtrans = color.transition(dbg, lbg)
		local boxanim = rubato.timed {
			duration   = 0.2,
			intro      = 0.1,
			subscribed = function(pos)
				boxed.shape.bgcol.bg = boxtrans(pos).hex
			end
		}

		boxed.shape:connect_signal("mouse::enter", function()
			boxanim.target = 1
			w = mouse.current_wibox
			if w then
				old_cursor, old_wibox = w.cursor, w
				w.cursor = "hand1"
			end
		end)

		boxed.shape:connect_signal("mouse::leave", function()
			boxanim.target = 0
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end)

		awesome.connect_signal("optimize::toggle", function(optimized)
			boxanim.duration = (optimized and 0.01 or 0.2)
		end)
	end

	return boxed
end

helpers.prembox = function(w, padding, have_margin, tl, tr, br, bl, dbg, lbg)
	local dbg = color.color { hex = dbg or beautiful.dbg }
	local lbg = color.color { hex = lbg or beautiful.lbg }
	local padding = padding or 2

	local margin

	if have_margin ~= false then
		margin = 4
	end

	local boxed = wibox.widget
	{
		{
			{
				{
					w,
			 		widget  = wibox.container.margin,
			 		margins = padding
				},
				widget = wibox.container.background,
				bg     = beautiful.dbg,
				id     = "bgcol"
			},
			widget = wibox.container.background,
			shape  = helpers.prrect(4, tl, tr, br, bl),
			id     = "shape"
		},
		widget  = wibox.container.margin,
		margins = margin
	}

	local boxtrans = color.transition(dbg, lbg)
	local boxanim = rubato.timed {
		duration   = 0.2,
		intro      = 0.1,
		subscribed = function(pos)
			boxed.shape.bgcol.bg = boxtrans(pos).hex
		end
	}

	boxed.shape:connect_signal("mouse::enter", function()
		boxanim.target = 1
		w = mouse.current_wibox
		if w then
			old_cursor, old_wibox = w.cursor, w
			w.cursor = "hand1"
		end
	end)

	boxed.shape:connect_signal("mouse::leave", function()
		boxanim.target = 0
		if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
		end
	end)

	awesome.connect_signal("optimize::toggle", function(optimized)
		boxanim.duration = (optimized and 0.01 or 0.2)
	end)

	return boxed
end

return helpers
