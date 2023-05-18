local beautiful = require("beautiful")
local naughty = require("naughty")
local icons = require("icons")
local gc = require("gears.color")
local playerctl = require("modules.bling").signal.playerctl.lib()

local prev = naughty.action {
	name = "Previous",
	icon = gc.recolor_image(icons.prev, beautiful.fg),
	icon_only = true,
}

local playpause = naughty.action {
	icon_only = true,
}

local skip = naughty.action {
	name = "Next",
	icon = gc.recolor_image(icons.skip, beautiful.fg),
	icon_only = true,
}

local playing = false
playerctl:connect_signal("playback_status", function(_, status)
	playing = status
	if playing then
		playpause.name = "Pause"
		playpause.icon = gc.recolor_image(icons.pause, beautiful.fg)
	else
		playpause.name = "Play"
		playpause.icon = gc.recolor_image(icons.play, beautiful.fg)
	end
end)

prev:connect_signal("invoked",      function() playerctl:previous()   end)
playpause:connect_signal("invoked", function() playerctl:play_pause() end)
skip:connect_signal("invoked",      function() playerctl:next()       end)

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name, extra)
	if new == true then

		naughty.notify({
			title    = extra.track .. ". " .. artist .. " - " .. title,
			text     =  "from <b><i>" .. album .. "</i></b> (" .. extra.year .. ")",
			image    = album_path,
			app_name = player_name,
			app_icon = gc.recolor_image(icons.music, beautiful.notifs),
			actions  = { prev, playpause, skip }
		})
	end
end)
