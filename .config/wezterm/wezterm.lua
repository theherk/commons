local wezterm = require 'wezterm';

-- Kaolin Bubblegum
-- local C_ACTIVE_BG = "#454459";
-- local C_ACTIVE_FG = "#6bd9db";
-- local C_BG = "#14171e";
-- local C_HL_1 = "#41b0f3";
-- local C_HL_2 = "#c79af4";
-- local C_INACTIVE_FG = "#575673";

-- Kaolin Dark
-- local C_ACTIVE_BG = "#4b5254";
-- local C_ACTIVE_FG = "#e4e4e8";
-- local C_BG = "#18181b";
-- local C_HL_1 = "#f2c866";
-- local C_HL_2 = "#e36d5b";
-- local C_INACTIVE_FG = "#4b5254";

-- Night Owl
-- local C_ACTIVE_BG = "#674ba5";
-- local C_ACTIVE_FG = "#e2dded";
-- local C_BG = "#011627";
-- local C_HL_1 = "#7fdbca";
-- local C_HL_2 = "#addb67";
-- local C_INACTIVE_FG = "#8ba2b6";

-- tokyonight
local C_ACTIVE_BG = "#454459";
local C_ACTIVE_FG = "#7dcfff";
local C_BG = "#1a1b26";
local C_HL_1 = "#7aa2f7";
local C_HL_2 = "#bb9af7";
local C_INACTIVE_FG = "#575673";

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  if tab.is_active then
    return {
      {Foreground={Color=C_HL_1}},
      {Text=" " .. tab.tab_index+1},
      {Foreground={Color=C_HL_2}},
      {Text=": "},
      {Foreground={Color=C_ACTIVE_FG}},
      {Text=tab.active_pane.title .. " "},
      {Background={Color=C_BG}},
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
    {Foreground={Color=C_HL_1}},
    {Text="|"},
  }
end
)

return {
  leader = { key="a", mods="CTRL"},
  color_scheme = "tokyonight",
  font = wezterm.font("VictorMono Nerd Font"),
  font_size = 20.0,
  tab_bar_at_bottom = true,
  tab_max_width = 96,
  use_fancy_tab_bar = false,

  colors = {
    tab_bar = {
      background = C_BG,
      new_tab = {
        bg_color = C_BG,
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
      },
    }
  },

  keys = {
    {key="a", mods="LEADER|CTRL", action=wezterm.action{SendString="\x01"}},

    -- Mode
    {key="x", mods="LEADER", action=wezterm.action.ActivateCopyMode},
    {key=" ", mods="LEADER", action=wezterm.action.QuickSelect},

    -- Pane Management
    {key="s", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="v", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="w", mods="LEADER", action=wezterm.action{CloseCurrentPane={confirm=false}}},

    -- Navigation
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
  }
}
