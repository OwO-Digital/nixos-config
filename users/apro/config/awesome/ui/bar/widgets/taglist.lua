local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local color = require("modules.color")
local rubato = require("modules.rubato")
local naughty = require("naughty")

local taglist_buttons = gears.table.join(
					awful.button({        }, 1, function(t) t:view_only() end),
					awful.button({ modkey }, 1, function(t)
						if client.focus then
							client.focus:move_to_tag(t)
						end
					end),
					awful.button({        }, 3, awful.tag.viewtoggle),
					awful.button({ modkey }, 3, function(t)
						if client.focus then
							client.focus:toggle_tag(t)
						end
					end),
					awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
					awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
				)

local dbg = color.color { hex = beautiful.dbg }
local lbg = color.color { hex = beautiful.lbg }

local tagtrans = color.transition(dbg, lbg)

local tag_spacing, tag_margins
if bar_orientation == "vertical" then
	tag_spacing = 0
	tag_padding = 1
	tag_margins = 2
elseif bar_orientation == "horizontal" then
	tag_spacing = 2
	tag_padding = 6
	tag_margins = nil
end

return function(s)
	local taglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout  = {
			layout  = wibox.layout.fixed[bar_orientation],
			spacing = tag_spacing,
		},
		widget_template = {
			{
				{
					{
						{
							id     = "text_role",
							widget = wibox.widget.textbox,
							align  = "center",
							valign = "center"
						},
						widget  = wibox.container.margin,
						margins = tag_padding,
					},
					id     = "background_role",
					widget = wibox.container.background,
				},
				shape = gears.shape.circle,
				widget = wibox.container.background,
				id = "shape"
			},
			widget = wibox.container.margin,
			margins = tag_margins,
			create_callback = function(self, t)
				local taganim = rubato.timed {
					duration   = 0.2,
					intro      = 0.1,
					subscribed = function(pos)
						if not t.selected then
							self.shape.background_role.bg = tagtrans(pos).hex
						end
					end
				}

				self.shape:connect_signal("mouse::enter", function()
					taganim.target = 1
					local w = mouse.current_wibox
					if w then
						old_cursor, old_wibox = w.cursor, w
						w.cursor = "hand1"
					end
				end)

				self.shape:connect_signal("mouse::leave", function()
					taganim.target = 0
					if old_wibox then
						old_wibox.cursor = old_cursor
						old_wibox = nil
					end
				end)

				awesome.connect_signal("optimize::toggle", function(optimized)
					taganim.duration = (optimized and 0.01 or 0.2)
				end)
			end
		}
	}


	return helpers.embox(taglist, false, 2, false) 
end

