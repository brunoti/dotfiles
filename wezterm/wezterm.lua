local wezterm = require 'wezterm'

local nerd_font = function(font)
  return wezterm.font_with_fallback({
    font,
    {
      family = "Symbols Nerd Font Mono",
      scale = 1.0,
    },
  })
end

return {
  color_scheme = "Tokyo Night",

  enable_kitty_graphics = true,

  enable_csi_u_key_encoding = true,
  -- Font settings
  font_size = 13.5,
  line_height = 1.2,
  bold_brightens_ansi_colors = false,
  font = nerd_font {
    family = "Iosevka",
    weight = "Medium",
  },
  font_rules = {
    -- {
    -- 	intensity = 'Bold',
    -- 	italic = true,
    -- 	font = nerd_font {
    -- 		family = 'Victor Mono',
    -- 		weight = 'Bold',
    -- 		style = "Italic",
    -- 	},
    -- },
    -- {
    -- 	italic = true,
    -- 	intensity = 'Half',
    -- 	font = nerd_font {
    -- 		family = 'Victor Mono',
    -- 		weight = 'Medium',
    -- 		style = "Italic",
    -- 	},
    -- },
    -- {
    -- 	italic = true,
    -- 	intensity = 'Normal',
    -- 	font = nerd_font {
    -- 		family = 'Victor Mono',
    -- 		weight = 'DemiBold',
    -- 		style = "Italic",
    -- 	},
    -- },
  },
  use_fancy_tab_bar = false,
  show_tabs_in_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  enable_tab_bar = false,
  adjust_window_size_when_changing_font_size = false,
  cell_width = 1,

  -- Window settings
  window_frame = {
  },
  window_padding = {
    left = 10,
    right = 10,
    top = 16,
    bottom = 16,
  },
  window_decorations = "RESIZE",
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

  default_cursor_style = 'SteadyBlock',
}
