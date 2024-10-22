local wezterm = require 'wezterm';

-- local font = 'JetBrainsMono Nerd Font Mono'
local font = 'ZedMono Nerd Font Mono'
local font_size = 14.5
local line_height = 1.4

return {
	enable_scroll_bar = false,
	font = wezterm.font(font),
	font_size = font_size,
	line_height = line_height,
	use_fancy_tab_bar = false,
	show_tabs_in_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,
	enable_tab_bar = false,
	default_cursor_style = 'SteadyBlock',
	window_padding = {
		left = 40,
		right = 40,
		top = 40,
		bottom = 10,
	},
	window_close_confirmation = "AlwaysPrompt",
	color_scheme = "Catppuccin Mocha",
	keys = {
		{
			key = 'r',
			mods = 'CMD|SHIFT',
			action = wezterm.action.ReloadConfiguration,
		},
		{
			key = 'f',
			mods = 'CTRL',
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = 'v',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.PasteFrom('Clipboard'),
		},
	},
}
