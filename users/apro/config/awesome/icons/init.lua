local wibox = require("wibox")
local gfs   = require("gears.filesystem")
local cols  = require("themes.cols." .. theme)
local dir   = gfs.get_configuration_dir() .. "icons/"

local icons = {
	-- window layouts
	tile       = dir .. "layouts/tile.png",
	tilebottom = dir .. "layouts/tilebottom.png",
	centered   = dir .. "layouts/centered.png",
	mstab      = dir .. "layouts/mstab.png",
	fairv      = dir .. "layouts/fairv.png",
	fairh      = dir .. "layouts/fairh.png",
	floating   = dir .. "layouts/floating.png",
	max1       = dir .. "layouts/max1.png",
	max2       = dir .. "layouts/max2.png",

	-- keyboard layouts
	flag_cz    = dir .. "kblayouts/flag_cz.svg",
	flag_us    = dir .. "kblayouts/flag_us.svg",
	flag_de    = dir .. "kblayouts/flag_de.svg",
	flag_es    = dir .. "kblayouts/flag_es.svg",
	flag_fr    = dir .. "kblayouts/flag_fr.svg",
	flag_ru    = dir .. "kblayouts/flag_ru.svg",
	flag_jp    = dir .. "kblayouts/flag_jp.svg",
	
	-- titlebar buttons
	btn        = dir .. "titlebar/button.svg",
	closeicon  = dir .. "titlebar/closeicon.svg",
	maxicon    = dir .. "titlebar/maxicon.svg",
	minicon    = dir .. "titlebar/minicon.svg",

	-- music icons
	music      = dir .. "music/note.svg",
	play       = dir .. "music/play.svg",
	pause      = dir .. "music/pause.svg",
	prev       = dir .. "music/prev.svg",
	skip       = dir .. "music/next.svg",

	-- battery icons
	charging   = dir .. "battery/charging.svg",

	-- notif icons
	notif      = dir .. "notifs/default.svg",

	-- power icons
	power	= dir .. "power/power.svg",
	restart	= dir .. "power/restart.svg",
	sleep	= dir .. "power/sleep.svg",
	log_out	= dir .. "power/log-out.svg",

	-- system icons
	wifi		= dir .. "system/wifi.svg",
	bluetooth	= dir .. "system/bluetooth.svg",
	eye_candy	= dir .. "system/eye-candy.svg",
	night_light	= dir .. "system/night-light.svg",
}

if gfs.file_readable(os.getenv("HOME") .. "/.face") then
	icons.user = os.getenv("HOME") .. "/.face"
else
	icons.user = wibox.widget.draw_to_image_surface (wibox.widget {
			wibox.widget.imagebox(dir .. "default-avatar.png"),
			widget = wibox.container.background,
			bg = cols.pfpbg
		})
end

-- distro
local distro = io.popen("sh -c 'source /etc/os-release; echo $ID'"):read("*l")
if gfs.dir_readable(dir .. "distros/" .. distro) then
	icons.distro = require("icons.distros." .. distro)
else
	icons.distro = require("icons.distros.generic")
end

return icons
