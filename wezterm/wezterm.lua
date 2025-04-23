local wezterm = require 'wezterm'

return {
  -- Import Catppuccin-Mocha theme
  color_scheme = "Catppuccin Mocha",

  -- Font settings
  font_size = 15.0,
  line_height = 2.5,
  bold_brightens_ansi_colors = true,
  freetype_load_flags = 'DEFAULT',
  freetype_load_target = 'Light',
  front_end = 'Software',
  font = wezterm.font_with_fallback({
    {
      family = "CommitMono Nerd Font",
      harfbuzz_features = {"ss01", "ss02", "ss03", "ss04", "ss05"},
      weight = "Regular",
    },
  }),
  use_fancy_tab_bar = false,
  show_tabs_in_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  enable_tab_bar = false,
  adjust_window_size_when_changing_font_size = false,
  cell_width = 1,

  -- Window settings
  window_frame = {
  },
  hide_tab_bar_if_only_one_tab = true,

  cursor_blink_rate = 0,

  -- Scrollback settings
  scrollback_lines = 9999999,

  -- Keybindings
  keys = {
    {
      key = "r",
      mods = "CMD",
      action = wezterm.action.ReloadConfiguration
    },
  },

  -- Add this to remove the title bar
  -- window_decorations = "NONE",

  default_cursor_style = 'SteadyBlock',
}
