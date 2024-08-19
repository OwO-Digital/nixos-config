wezterm = require 'wezterm'

{
	check_for_updates: false
	front_end: "WebGpu"

	color_scheme: 'sonokai-shusia'
	font: wezterm.font_with_fallback {
		'Maple Mono NF'
		'Twemoji'
	}
	font_size: 12.0
	bold_brightens_ansi_colors: false

	adjust_window_size_when_changing_font_size: false
	enable_scroll_bar: true
	exit_behavior_messaging: "Terse"

	hide_tab_bar_if_only_one_tab: true
	use_fancy_tab_bar: false
	tab_max_width: 64
	--show_tab_index_in_tab_bar: false

	force_reverse_video_cursor: true
	default_cursor_style: "BlinkingBlock"
	cursor_blink_rate: 400
	cursor_blink_ease_in: "Constant"
	cursor_blink_ease_out: "Constant"

	--window_background_opacity: 0.9
	window_background_opacity: 1
	inactive_pane_hsb: {
		saturation: 1
		brightness: 0.9
	}

	animation_fps: 60
}
