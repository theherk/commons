local wezterm = require("wezterm")

local module = {}

local schemes = {
  dark = "Catppuccin Frappe",
  light = "Catppuccin Latte (Gogh)",
}

local function resolve_scheme()
  local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Light"
  if appearance:find("Dark") then
    return schemes.dark
  end
  return schemes.light
end

local function build_colors(selected_scheme)
  local colors = {}
  local scheme = wezterm.get_builtin_color_schemes()[selected_scheme]

  colors.active_fg = scheme.ansi[6]
  colors.bg = scheme.background
  colors.hl_1 = scheme.ansi[5]
  colors.hl_2 = scheme.ansi[4]
  colors.hl_3 = scheme.ansi[8]
  local bg = wezterm.color.parse(scheme.background)
  local _, _, l, _ = bg:hsla()
  if l > 0.5 then
    colors.inactive_fg = bg:complement_ryb():darken(0.3)
    colors.panel_bg = bg:darken(0.069)
  else
    colors.inactive_fg = bg:complement_ryb():lighten(0.3)
    colors.panel_bg = bg:lighten(0.139)
  end
  colors.active_bg = colors.panel_bg

  scheme.cursor_bg = colors.active_fg
  scheme.split = colors.hl_3

  scheme.tab_bar = {
    background = colors.bg,
    new_tab = {
      bg_color = colors.bg,
      fg_color = colors.hl_2,
    },
    active_tab = {
      bg_color = colors.active_bg,
      fg_color = colors.active_fg,
    },
    inactive_tab = {
      bg_color = colors.bg,
      fg_color = colors.inactive_fg,
    },
    inactive_tab_hover = {
      bg_color = colors.bg,
      fg_color = colors.inactive_fg,
    },
  }

  return colors, scheme
end

-- Initial build for module-level access
local selected_scheme = resolve_scheme()
local colors, _ = build_colors(selected_scheme)
module.colors = colors

function module.apply_to_config(config)
  config.font = wezterm.font_with_fallback({
    "VictorMono Nerd Font",
    "Apple Color Emoji",
  })
  config.font_size = 18
  config.inactive_pane_hsb = {
    saturation = 0.66,
    brightness = 0.43,
  }
  config.macos_window_background_blur = 23
  config.tab_bar_at_bottom = true
  config.tab_max_width = 96
  config.unicode_version = 14
  config.use_fancy_tab_bar = false
  config.window_background_opacity = 1.0
  config.window_decorations = "RESIZE"

  -- Apply current appearance scheme
  local scheme_name = resolve_scheme()
  local c, scheme = build_colors(scheme_name)
  config.color_scheme = scheme_name
  config.color_schemes = { [scheme_name] = scheme }
  config.command_palette_bg_color = c.panel_bg
  config.command_palette_fg_color = c.hl_1
end

-- Live-switch on system appearance change
wezterm.on("window-config-reloaded", function(window, _)
  local overrides = window:get_config_overrides() or {}
  local scheme_name = resolve_scheme()
  if overrides.color_scheme ~= scheme_name then
    local c, scheme = build_colors(scheme_name)
    overrides.color_scheme = scheme_name
    overrides.color_schemes = { [scheme_name] = scheme }
    overrides.command_palette_bg_color = c.panel_bg
    overrides.command_palette_fg_color = c.hl_1
    window:set_config_overrides(overrides)
  end
end)

return module
