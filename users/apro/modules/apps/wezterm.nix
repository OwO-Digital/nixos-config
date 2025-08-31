{ config, lib, pkgs, ... }: {

  programs.wezterm = {
    enable = true;
    package = pkgs.stable.wezterm;

    extraConfig = /* lua */ ''
      wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
      	local title = tab.active_pane.title
      	local left = "█"
      	local right = "█"
      	local div = "█"
      	if tab.tab_index == 0 then
      		left = ""
      		div = " "
      	end
      	if tab.tab_index == #tabs - 1 then
      		right = " "
      	end 

      	local tab_background = config.colors.tab_bar.inactive_tab.bg_color
      	local tab_foreground = config.colors.tab_bar.inactive_tab.fg_color

      	local background = config.colors.tab_bar.background

      	if tab.is_active then
      		tab_background = config.colors.tab_bar.active_tab.bg_color
      		tab_foreground = config.colors.tab_bar.active_tab.fg_color
      	elseif hover then
      		tab_background = config.colors.tab_bar.inactive_tab_hover.bg_color
      		tab_foreground = config.colors.tab_bar.inactive_tab_hover.fg_color
      	end

      	return {
      		{ Background = { Color = background } },
      		{ Foreground = { Color = config.colors.tab_bar.inactive_tab.bg_color } },
      		{ Text = div },
      		{ Foreground = { Color = tab_background } },
      		{ Text = left },
      		{ Background = { Color = tab_background } },
      		{ Foreground = { Color = tab_foreground } },
      		{ Text = title },
      		{ Background = { Color = background } },
      		{ Foreground = { Color = tab_background } },
      		{ Text = right },
      	}
      end)

      wezterm.on('update-status', function(window, pane)
      	local meta = pane:get_metadata() or {}
      	local overrides = window:get_config_overrides() or {}
      	if meta.password_input then
      		overrides.cursor_blink_ease_in  = "EaseIn"
      		overrides.cursor_blink_ease_out = "EaseOut"
      	else
      		overrides.cursor_blink_ease_in  = "Constant"
      		overrides.cursor_blink_ease_out = "Constant"
      	end
      	window:set_config_overrides(overrides)
      end)

      return {
      		-- Font
      		font = wezterm.font_with_fallback {
      			{
      				family = "Iosevka Nerd Font",
      				harfbuzz_features = { "ss14=1" },
      			},
      			"Blobmoji",
      		},
      		font_rules = {
      			{
      				italic = true,
      				font = wezterm.font {
      					family = "Maple Mono",
      					style  = "Italic",
      				}
      			}
      		},
      		-- Font size
      		font_size = 12.0,
      		default_cursor_style = "BlinkingUnderline",
      		use_fancy_tab_bar = false,
      		tab_bar_at_bottom = true,

      		color_scheme = 'Everblush',
      		-- Tab Colors
      		colors = {
      				scrollbar_thumb = "#b3b9b8",
      				split = "#dadada",
      				tab_bar = {
      						background = "#141b1e",

      						active_tab = {
      								bg_color = "#bab3e5",
      								fg_color = "#22292b",

      								intensity = "Normal",
      								underline = "None",
      								italic = false,
      								strikethrough = false
      						},

      						inactive_tab = {
      								bg_color = "#22292b",
      								fg_color = "#dadada"
      						},

      						inactive_tab_hover = {
      								bg_color = "#8ad8ef",
      								fg_color = "#22292b",
      								italic = true
      						},

      						new_tab = {
      								bg_color = "#141b1e",
      								fg_color = "#dadada"
      						},

      						new_tab_hover = {
      								bg_color = "#ce89df",
      								fg_color = "#dadada",
      								italic = true
      						}
      				}
      		}
      }
      		'';
    colorSchemes = {
      Everblush = {
        foreground = "#dadada";
        background = "#141b1e";
        cursor_bg = "#dadada";
        cursor_fg = "#141b1e";
        cursor_border = "#dadada";
        selection_fg = "141b1e";
        selection_bg = "#dadada";
        ansi = [
          "#232a2d"
          "#e57474"
          "#8ccf7e"
          "#e5c76b"
          "#67b0e8"
          "#c47fd5"
          "#6cbfbf"
          "#b3b9b8"
        ];
        brights = [
          "#2d3437"
          "#ef7d7d"
          "#96d988"
          "#f4d67a"
          "#71baf2"
          "#ce89df"
          "#67cbe7"
          "#bdc3c2"
        ];
      };
    };
  };
}
