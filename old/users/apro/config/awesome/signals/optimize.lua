local awful = require("awful")

awesome.connect_signal("optimize::toggle", function(optimize)
	optimized = optimize
	if optimize then
		awful.spawn.with_shell("kill $(pidof picom)")
	else
		for _, app in pairs(autostart) do
			if app:find("^picom ") then
				awful.spawn(app)
			end
		end
	end
end)

