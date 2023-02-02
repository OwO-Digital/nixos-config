local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local menubar = require("menubar")
local naughty = require("naughty")
local wibox = require("wibox")
local rubato = require("modules.rubato")
local icons = require("icons")
local helpers = require("helpers")

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.position = "top_right"
naughty.config.icon_dirs = {
	os.getenv("HOME") .. "/.nix-profile/share/icons/Papirus/",
	os.getenv("HOME") .. "/.nix-profile/share/icons/Adwaita/",
	os.getenv("HOME") .. "/.nix-profile/share/icons/HighContrast/",
	os.getenv("HOME") .. "/.nix-profile/share/pixmaps/",
}
naughty.config.icon_formats = { "png", "svg" }
naughty.connect_signal("request::display", function(n)

	local timeout = n.timeout
	n.timeout = 999999

	local icon = wibox.widget {
		image  = n.app_icon
		      or menubar.utils.lookup_icon(n.app_name:lower()),
		forced_width  = 18,
		forced_height = 18,
		widget = wibox.widget.imagebox,
	}

	if not (n.app_icon or menubar.utils.lookup_icon(n.app_name:lower())) then
		icon.image = gears.color.recolor_image(icons.notif, beautiful.notifs)
	end

	if not n.app_name or n.app_name == "" then
		n.app_name = "Awesome"
	elseif helpers.contains(beautiful.nocap, n.app_name:lower()) then
	else
		n.app_name = n.app_name:gsub("^%l", string.upper):gsub("%s%l", string.upper)
	end

	local app_name = wibox.widget {
		widget = wibox.widget.textbox,
		font = helpers.join({beautiful.uifontsp, "Bold", beautiful.fontsize * 1.2}),
		text = n.app_name
	}

	local x = wibox.widget {
		widget = wibox.widget.imagebox,
		image = gears.color.recolor_image(icons.closeicon, beautiful.notifs),
	}

	local timeout_graph = wibox.widget {
		widget = wibox.container.arcchart,
		min_value = 0,
		max_value = 100,
		value = 0,
		thickness = 2,
		rounded_edge = true,
		colors = { beautiful.notifs },
		bg = beautiful.lbg,
		forced_width  = 18,
		forced_height = 18,
		x,
		buttons = {
			awful.button({ }, 1, function() n:destroy(naughty.notification_closed_reason.dismissed_by_user) end)
		}
	}

	local title = wibox.widget {
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		speed = 100,
		rate = 144,
		{
			widget = wibox.widget.textbox,
			font = helpers.join({beautiful.uifontsp, "Medium", beautiful.fontsize * 1.1}),
			markup = n.title,
		}
	}

	local message = wibox.widget {
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		speed = 100,
		rate = 144,
		{
			widget = wibox.widget.textbox,
			font = helpers.join({beautiful.uifontsp, beautiful.fontsize * 1.1}),
			markup = n.message,
		}
	}

	local image
	if n.image then
		image = wibox.widget {
			widget = wibox.widget.imagebox,
			image = n.image,
			clip_shape = helpers.rrect(beautiful.border_radius),
			background = "#ff0000",
			resize = true,
			upscale = false,
			halign = "center",
			valign = "center",
			forced_height = beautiful.get_font_height(helpers.join({beautiful.uifontsp, beautiful.fontsize})) * 3,
			forced_width  = beautiful.get_font_height(helpers.join({beautiful.uifontsp, beautiful.fontsize})) * 3,
		}
	else
		image = nil
	end

	local head = wibox.widget {
		{
			{
				icon,
				widget = wibox.container.margin,
				margins = {
					left = 4,
					right = 4,
					top = 2,
					bottom = 2,
				}
			},
			app_name,
			layout = wibox.layout.fixed.horizontal
		},
		nil,
		{
			timeout_graph,
			widget = wibox.container.margin,
			margins = 3,
		},
		layout = wibox.layout.align.horizontal,
	}

	local body = wibox.widget { 
		{
			{
				{
					title,
					message,
					layout = wibox.layout.flex.vertical
				},
				widget = wibox.container.margin,
				margins = {
					left = 4,
					right = 4,
					bottom = 4,
				}
			},
			widget = wibox.container.constraint,
			width = 500,
			strategy = "max",
		},
		nil,
		image,
		layout = wibox.layout.align.horizontal,
	}

	local actions = wibox.widget {
		widget = naughty.list.actions,
		notification = n,
		base_layout = wibox.widget {
			layout = wibox.layout.flex.horizontal,
			spacing = beautiful.border_size * 2,
		},
		widget_template = {
			{
				{
					{
						id            = "icon_role",
						forced_height = 16,
						forced_width  = 16,
						widget        = wibox.widget.imagebox
					},
					{
						id     = "text_role",
						widget = wibox.widget.textbox,
						font = helpers.join({beautiful.uifontsp, beautiful.fontsize * 1.1}),
					},
					layout = wibox.layout.stack
				},
				widget = wibox.container.place,
				halign = "center",
				valign = "center",
			},
			id = "background_role",
			widget = wibox.container.background,
		},
		style = {
			bg_normal = beautiful.bg,
			bg_selected = beautiful.lbg,
			underline_normal = false,
			underline_selected = false,
		}
	}

	local widget = naughty.layout.box {
		notification = n,
		type = "notification",
		cursor = "hand2",
		shape = gears.shape.rectangle,
		bg = "#00000000",
		maximum_width = 500 + beautiful.get_font_height(helpers.join({beautiful.uifontsp, beautiful.fontsize})) * 3 + 12 + beautiful.border_size * 3,
		minimum_width = 300,
		widget_template = {
			{
				{
					{
						{
							head,
							{
								{
									{
										{
											body,
											widget = wibox.container.margin,
											margins = 6
										},
										widget = wibox.container.background,
										shape = helpers.rrect(beautiful.border_radius),
										bg = beautiful.bg,
									},
									{
										actions,
										widget = wibox.container.background,
										shape = helpers.rrect(beautiful.border_radius),
									},
									layout = wibox.layout.fixed.vertical,
									spacing = beautiful.border_size * 2,
								},
								widget = wibox.container.margin,
								margins = beautiful.border_size * 2,
							},
							layout = wibox.layout.fixed.vertical,
						},
						widget = wibox.container.background,
						bg = beautiful.dbg,
					},
					widget = wibox.container.background,
					shape = helpers.rrect(beautiful.border_radius - beautiful.border_size)
				},
				widget = wibox.container.margin,
				margins = beautiful.border_size
			},
			widget = wibox.container.background,
			bg = beautiful.notifs,
			shape = helpers.rrect(beautiful.border_radius)
		}
	}

	widget.buttons = { }

	local anim = rubato.timed {
		intro = 0,
		duration = timeout,
		subscribed = function(pos, time)
			timeout_graph.value = pos
			if time == timeout then
				n:destroy()
			end
		end
	}

	widget:connect_signal("mouse::enter", function()
		anim.pause = true
	end)

	widget:connect_signal("mouse::leave", function()
		anim.pause = false
	end)
	
	anim.target = 100
end)
