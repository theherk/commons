local wezterm = require 'wezterm';
local TRIANGLE = utf8.char(0x25B2)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  if tab.is_active then
    return {
      {Foreground={Color="#7fdbca"}},
      {Text=" " .. tab.tab_index+1 .. ": "},
      {Foreground={Color="#e2dded"}},
      {Text=tab.active_pane.title .. " "},
      {Background={Color="#011627"}},
      {Foreground={Color="#7fdbca"}},
      {Text="|"},
    }
  end
  return {
    {Foreground={Color="#7fdbca"}},
    {Text=" " .. tab.tab_index+1 .. ": "},
    {Foreground={Color="#8ba2b6"}},
    {Text=tab.active_pane.title .. " "},
    {Foreground={Color="#7fdbca"}},
    {Text="|"},
  }
end)

return {
  leader = { key="a", mods="CTRL"},
  color_scheme = "Night Owl",
  font = wezterm.font("VictorMono Nerd Font"),
  font_size = 20.0,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  tab_max_width = 48,
  use_fancy_tab_bar = false,

  colors = {
    tab_bar = {
      background = "#011627",
      new_tab = {
        bg_color = "#011627",
        fg_color = "#addb67",
      },
      active_tab = {
        bg_color = "#674ba5",
        fg_color = "#e2dded",
        intensity = "Bold",
      },
      inactive_tab = {
        bg_color = "#011627",
        fg_color = "#8ba2b6",
      },
      inactive_tab_hover = {
        bg_color = "#7e57c2",
        fg_color = "#8ba2b6",
      },
    },
  },

  keys = {
    {key="a", mods="LEADER|CTRL", action=wezterm.action{SendString="\x01"}},
    {key="s", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="v", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="w", mods="LEADER", action=wezterm.action{CloseCurrentPane={confirm=false}}},
    {key = "h", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
    {key = "l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
    {key = "k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
    {key = "j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
    {key="]", mods="LEADER", action=wezterm.action{ActivateTabRelative=1}},
    {key="[", mods="LEADER", action=wezterm.action{ActivateTabRelative=-1}},
    {key="1", mods="LEADER", action=wezterm.action{ActivateTab=0}},
    {key="2", mods="LEADER", action=wezterm.action{ActivateTab=1}},
    {key="3", mods="LEADER", action=wezterm.action{ActivateTab=2}},
    {key="4", mods="LEADER", action=wezterm.action{ActivateTab=3}},
    {key="5", mods="LEADER", action=wezterm.action{ActivateTab=4}},
    {key="6", mods="LEADER", action=wezterm.action{ActivateTab=5}},
    {key="7", mods="LEADER", action=wezterm.action{ActivateTab=6}},
    {key="8", mods="LEADER", action=wezterm.action{ActivateTab=7}},
    {key="9", mods="LEADER", action=wezterm.action{ActivateTab=8}},
    {key="0", mods="LEADER", action=wezterm.action{ActivateTab=-1}},
    {key="0", mods="SUPER", action=wezterm.action{ActivateTab=-1}},
  },

  window_frame = {
    font = wezterm.font({family="VictorMono Nerd Font", weight="Bold"}),
    font_size = 18.0,
  },
}
