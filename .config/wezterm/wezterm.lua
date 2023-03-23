local wezterm = require 'wezterm';
local act = wezterm.action

local selected_scheme = "tokyonight";
local scheme = wezterm.get_builtin_color_schemes()[selected_scheme]

local C_ACTIVE_BG = scheme.selection_bg;
local C_ACTIVE_FG = scheme.ansi[6];
local C_BG = scheme.background;
local C_HL_1 = scheme.ansi[5];
local C_HL_2 = scheme.ansi[4];
local C_INACTIVE_FG;
local bg = wezterm.color.parse(scheme.background);
local h, s, l, a = bg:hsla();
if l > 0.5 then
  C_INACTIVE_FG = bg:complement_ryb():darken(0.3);
else
  C_INACTIVE_FG = bg:complement_ryb():lighten(0.3);
end

scheme.tab_bar = {
  -- background = C_BG,
  background = "none",
  new_tab = {
    -- bg_color = C_BG,
    bg_color = "none",
    fg_color = C_HL_2,
  },
  active_tab = {
    bg_color = C_ACTIVE_BG,
    fg_color = C_ACTIVE_FG,
  },
  inactive_tab = {
    bg_color = C_BG,
    fg_color = C_INACTIVE_FG,
  },
  inactive_tab_hover = {
    bg_color = C_BG,
    fg_color = C_INACTIVE_FG,
  }
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  if tab.is_active then
    return {
      {Foreground={Color=C_HL_1}},
      {Text=" " .. tab.tab_index+1},
      {Foreground={Color=C_HL_2}},
      {Text=": "},
      {Foreground={Color=C_ACTIVE_FG}},
      {Text=tab.active_pane.title .. " "},
      -- {Background={Color=C_BG}},
      {Background={Color="none"}},
      {Foreground={Color=C_HL_1}},
      {Text="|"},
    }
  end
  return {
    {Foreground={Color=C_HL_1}},
    {Text=" " .. tab.tab_index+1},
    {Foreground={Color=C_HL_2}},
    {Text=": "},
    {Foreground={Color=C_INACTIVE_FG}},
    {Text=tab.active_pane.title .. " "},
    {Background={Color="none"}},
    {Foreground={Color=C_HL_1}},
    {Text="|"},
  }
end
)

wezterm.on('update-right-status', function(window, pane)
  text = ""
  if window:active_key_table() then
    text = text .. wezterm.format({
    {Foreground={Color=C_HL_1}},
    {Text='TABLE: '},
    {Foreground={Color=C_HL_2}},
    {Text=window:active_key_table()},
  })
  end
  window:set_right_status(text)
end
)

return {
  leader = { key="a", mods="CTRL"},
  color_schemes = {
    [selected_scheme] = scheme
  },
  color_scheme = selected_scheme,
  window_background_opacity = 0.88,
  inactive_pane_hsb = {
    saturation = 0.66,
    brightness = 0.54,
  },
  font = wezterm.font("VictorMono Nerd Font"),
  font_size = 20,
  tab_bar_at_bottom = true,
  tab_max_width = 96,
  use_fancy_tab_bar = false,
  window_decorations = "RESIZE",
  key_tables = {
    resize_pane = {
      { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'Escape', action = 'PopKeyTable' },
    },
  },
  keys = {
    { key = "a", mods = "LEADER|CTRL", action = act.SendString "\x01" },

    -- Mode
    { key = "x", mods="LEADER", action = act.ActivateCopyMode },
    { key = " ", mods="LEADER", action = act.QuickSelect },

    -- Pane Management
    { key = "s", mods="LEADER", action = act.SplitVertical { domain="CurrentPaneDomain" } },
    { key = "v", mods="LEADER", action = act.SplitHorizontal { domain="CurrentPaneDomain" } },
    { key = "w", mods="LEADER", action = act.CloseCurrentPane { confirm=false } },
    { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },

    -- Navigation
    { key = "h", mods="LEADER", action = act.ActivatePaneDirection "Left" },
    { key = "l", mods="LEADER", action = act.ActivatePaneDirection "Right" },
    { key = "k", mods="LEADER", action = act.ActivatePaneDirection "Up" },
    { key = "j", mods="LEADER", action = act.ActivatePaneDirection "Down" },
    { key = "]", mods="LEADER", action = act.ActivateTabRelative(1) },
    { key = "[", mods="LEADER", action = act.ActivateTabRelative(-1) },
    { key = "1", mods="LEADER", action = act.ActivateTab(0) },
    { key = "2", mods="LEADER", action = act.ActivateTab(1) },
    { key = "3", mods="LEADER", action = act.ActivateTab(2) },
    { key = "4", mods="LEADER", action = act.ActivateTab(3) },
    { key = "5", mods="LEADER", action = act.ActivateTab(4) },
    { key = "6", mods="LEADER", action = act.ActivateTab(5) },
    { key = "7", mods="LEADER", action = act.ActivateTab(6) },
    { key = "8", mods="LEADER", action = act.ActivateTab(7) },
    { key = "9", mods="LEADER", action = act.ActivateTab(8) },
    { key = "0", mods="LEADER", action = act.ActivateTab(-1) },
    { key = "0", mods="SUPER", action = act.ActivateTab(-1) },
  },
}
