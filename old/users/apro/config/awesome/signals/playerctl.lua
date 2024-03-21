local beautiful = require("beautiful")
local naughty = require("naughty")
local icons = require("icons")
local gc = require("gears.color")
local playerctl = require("modules.bling").signal.playerctl.lib({metadata_v2 = true})

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

playerctl:connect_signal("metadata", function(_, metadata, album_art, new, player_name)
	if new == true then
		naughty.notify({
			title    = metadata.trackNumber .. ". " .. metadata.artist .. " - " .. metadata.title,
			text     =  "from <b><i>" .. metadata.album .. "</i></b> (" .. metadata.contentCreated .. ")",
			image    = album_art,
			app_name = player_name,
			app_icon = gc.recolor_image(icons.music, beautiful.notifs),
			actions  = { prev, playpause, skip }
		})
	end
end)
