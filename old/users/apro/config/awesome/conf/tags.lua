local awful = require("awful")

awful.screen.connect_for_each_screen(function(s)
	if s.geometry.height < s.geometry.width then
		awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])
	else
		awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[2])
	end

	awful.tag.add("6", {
	screen = s,
	layout = awful.layout.suit.floating,
	})
end)
