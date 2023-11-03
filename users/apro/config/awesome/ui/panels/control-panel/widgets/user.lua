local awful		= require("awful")
local beautiful	= require("beautiful")
local gears		= require("gears")
local helpers	= require("helpers")
local icons		= require("icons")
local wibox		= require("wibox")

local function get_uptime()
	local up_file = io.open("/proc/uptime", "r")
	local sys_time = up_file:read("*number")

	local time = {
		{"d", math.floor(sys_time / 60 / 60 / 24)},
		{"h", math.floor(sys_time / 60 / 60 % 24)},
		{"m", math.floor(sys_time / 60 % 60)},
	}

	local output = ""
	for _, t in pairs(time) do
		if t[2] > 0 then
			if output == "" then
				output = string.format("%i%s", t[2], t[1])
			else
				output = string.format("%s, %i%s", output, t[2], t[1])
			end
		end
	end

	return output
end

local user = wibox.widget {
	{
		{
			{
				image = icons.user,
				clip_shape = gears.shape.circle,
				resize = true,
				widget = wibox.widget.imagebox
			},
			{
				{
					{
						text = io.popen('whoami'):read('*all'),
						widget = wibox.widget.textbox
					},
					{
						text = get_uptime(),
						widget = wibox.widget.textbox
					},
					layout = wibox.layout.flex.vertical
				},
				top = 16,
				bottom = 16,
				left = beautiful.border_radius,
				widget = wibox.container.margin
			},
			layout = wibox.layout.fixed.horizontal
		},
		nil,
		{
			{
				{
					helpers.prembox(wibox.widget.imagebox(icons.power), 8, false, true, false, false, false, beautiful.bg),
					helpers.prembox(wibox.widget.imagebox(icons.restart), 8, false, false, true, false, false, beautiful.bg),
					spacing = beautiful.border_size * 2,
					layout = wibox.layout.flex.horizontal
				},
				height = 40,
				width = 80,
				strategy = "exact",
				widget = wibox.container.constraint
			},
			{
				{
					helpers.prembox(wibox.widget.imagebox(icons.sleep), 8, false, false, false, false, true, beautiful.bg),
					helpers.prembox(wibox.widget.imagebox(icons.log_out), 8, false, false, false, true, false, beautiful.bg),
					spacing = beautiful.border_size * 2,
					layout = wibox.layout.flex.horizontal
				},
				height = 40,
				width = 80,
				strategy = "exact",
				widget = wibox.container.constraint
			},
			spacing = beautiful.border_size * 2,
			layout = wibox.layout.flex.vertical
		},
		layout = wibox.layout.align.horizontal
	},
	height = 80,
	strategy = "exact",
	widget = wibox.container.constraint,
}

return helpers.embox(user, nil, 8, false)
