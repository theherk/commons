local wezterm = require("wezterm")

local module = {}
local colors = {}

local selected_scheme = "tokyonight_night"
local scheme = wezterm.get_builtin_color_schemes()[selected_scheme]

colors.active_bg = scheme.selection_bg
colors.active_fg = scheme.ansi[6]
colors.bg = scheme.background
colors.hl_1 = scheme.ansi[5]
colors.hl_2 = scheme.ansi[4]
local bg = wezterm.color.parse(scheme.background)
local _, _, l, _ = bg:hsla()
if l > 0.5 then
  colors.inactive_fg = bg:complement_ryb():darken(0.3)
  colors.panel_bg = bg:darken(0.069)
else
  colors.inactive_fg = bg:complement_ryb():lighten(0.3)
  colors.panel_bg = bg:lighten(0.069)
end

scheme.tab_bar = {
  -- background = colors.bg,
  background = "none",
  new_tab = {
    -- bg_color = colors.bg,
    bg_color = "none",
    fg_color = colors.hl_2,
  },
  active_tab = {
    bg_color = colors.active_bg,
    fg_color = colors.active_fg,
  },
  inactive_tab = {
    bg_color = "none",
    fg_color = colors.inactive_fg,
  },
  inactive_tab_hover = {
    bg_color = "none",
    fg_color = colors.inactive_fg,
  },
}

module.colors = colors

function module.apply_to_config(config)
  config.color_scheme = selected_scheme
  config.color_schemes = {
    [selected_scheme] = scheme,
  }
  config.command_palette_bg_color = colors.panel_bg
  config.command_palette_fg_color = colors.hl_1
  config.inactive_pane_hsb = {
    saturation = 0.66,
    brightness = 0.54,
  }
  config.font = wezterm.font("VictorMono Nerd Font")
  config.font_size = 19
  config.tab_bar_at_bottom = true
  config.tab_max_width = 96
  config.use_fancy_tab_bar = false
  config.window_background_opacity = 0.94247
  config.window_decorations = "RESIZE"
end

return module
