{ config, lib, pkgs, ... }: {

	wayland.windowManager.hyprland.settings = {

		exec-once = [
			"/etc/xdg/autostart/gnome-keyring-*.desktop"
			"/etc/X11/xinit/xinitrc.d/50-systemd-user.sh"
		];

		monitor = [
			"DP-1, 1920x1080@144, 0x0, 1"
			"HDMI-A-1, 1920x1080@60, 1920x-150, 1, transform, 1"
		];

		env = [
			"XCURSOR_SIZE,24"
			"HYPRCURSOR_SIZE,24"
		];

		general = {
			gaps_in = "5";
			gaps_out = "20";
			border_size = "2";

			"col.active_border"   = "rgba(33ccffee) rgba(00ff99ee) 45deg";
			"col.inactive_border" = "rgba(595959aa)";

			resize_on_border = "false";
			allow_tearing = "false";
			layout = "master";
		};

		debug.disable_logs = "false";

		decoration = {
			rounding = "10";
			rounding_power = "2";

			active_opacity   = "1.0";
			inactive_opacity = "1.0";

			shadow = {
				enabled = "true";
				range = "4";
				render_power = "3";
				color = "rgba(1a1a1aee)";
			};

			blur = {
				enabled = "true";
				size = "3";
				passes = "1";

				vibrancy = "0.1696";
			};
		};

		dwindle = {
			pseudotile = "true";
			preserve_split = "true";
		};

		master.new_status = "master";

		misc = {
			force_default_wallpaper = "-1";
			disable_hyprland_logo = "false";
			enable_swallow = "true";
			vrr = "2";
		};

		input = {
			kb_layout = "us";

			follow_mouse = "1";
			sensitivity = "0.7";
			accel_profile = "flat";

			touchpad.natural_scroll = "true";
		};

		gestures.workspace_swipe = "true";
	};
}
