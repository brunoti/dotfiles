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

local config = wezterm.config_builder()

-- Tokyo Night Dark.
config.color_scheme = "Tokyo Night"
config.colors = {
  cursor_bg = "#c0caf5",
  cursor_border = "#c0caf5",
  cursor_fg = "#1a1b26",
  selection_bg = "#283457",
  selection_fg = "#c0caf5",
  split = "#7aa2f7",
}

-- Ghostty-like rendering: one clean terminal surface, Nerd Font fallback,
-- roomy line height, no tab chrome.
config.font = nerd_font {
  family = "Iosevka Nerd Font",
  weight = "Medium",
}
config.font_size = 13.5
config.line_height = 1.2
config.cell_width = 1.0
config.bold_brightens_ansi_colors = false
config.font_rules = {
  {
    intensity = "Bold",
    font = nerd_font {
      family = "Iosevka Nerd Font",
      weight = "Bold",
    },
  },
  {
    italic = true,
    font = nerd_font {
      family = "Iosevka Nerd Font",
      style = "Italic",
    },
  },
  {
    intensity = "Bold",
    italic = true,
    font = nerd_font {
      family = "Iosevka Nerd Font",
      weight = "Bold",
      style = "Italic",
    },
  },
}

-- Terminal protocol features.
config.enable_kitty_graphics = true
config.enable_csi_u_key_encoding = true
config.term = "wezterm"

-- Window shape / spacing.
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 10,
  right = 10,
  top = 16,
  bottom = 16,
}
config.adjust_window_size_when_changing_font_size = false
config.window_background_opacity = 1.0
config.inactive_pane_hsb = {
  saturation = 0.95,
  brightness = 0.85,
}

-- Native title still updates via OSC/tmux/`wezterm cli set-window-title`,
-- which keeps ActivityWatch project tracking useful even with hidden chrome.
config.use_fancy_tab_bar = false
config.enable_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Cursor / scrollback.
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0
config.scrollback_lines = 100000
config.audible_bell = "Disabled"

-- Keybindings.
config.keys = {
  {
    key = "r",
    mods = "CMD",
    action = wezterm.action.ReloadConfiguration,
  },
}

return config
