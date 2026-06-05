local theme = require("theme")
local util = require("util")
local ws = require("workspace")
local wezterm = require("wezterm")

local act = wezterm.action
local module = {}

local copy_mode = nil
if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode
  table.insert(copy_mode, { key = "j", mods = "SUPER", action = act.CopyMode({ MoveByPage = 0.5 }) })
  table.insert(copy_mode, { key = "k", mods = "SUPER", action = act.CopyMode({ MoveByPage = -0.5 }) })
  table.insert(copy_mode, { key = "J", mods = "SUPER", action = act.CopyMode({ MoveByPage = 1 }) })
  table.insert(copy_mode, { key = "K", mods = "SUPER", action = act.CopyMode({ MoveByPage = -1 }) })
end

local key_tables = {
  copy_mode = copy_mode,

  launch_split = {
    { key = "a", action = util.launch_split({ "raicode", "-c" }) },
    { key = "b", action = util.launch_split({ "repo-browse.sh" }) },
    { key = "e", action = util.launch_split({ "nvp" }) },
    { key = "f", action = util.launch_split({ "yazi" }) },
    { key = "g", action = util.launch_split({ "lazygit" }) },
    { key = "u", action = util.launch_split({ "jjui" }) },
    { key = "Escape", action = "PopKeyTable" },
  },

  launch_vertical = {
    { key = "a", action = util.launch_vertical({ "raicode", "-c" }) },
    { key = "b", action = util.launch_vertical({ "repo-browse.sh" }) },
    { key = "e", action = util.launch_vertical({ "nvp" }) },
    { key = "f", action = util.launch_vertical({ "yazi" }) },
    { key = "g", action = util.launch_vertical({ "lazygit" }) },
    { key = "u", action = util.launch_vertical({ "jjui" }) },
    { key = "Escape", action = "PopKeyTable" },
  },

  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "Escape", action = "PopKeyTable" },
  },
}

local keys = {
  { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },
  { key = "Enter", mods = "SHIFT", action = act.SendKey({ key = "Enter", mods = "ALT" }) },

  -- Workpace and Pallette
  { key = "d", mods = "LEADER", action = ws.with_cache("default") },
  { key = "i", mods = "LEADER", action = ws.with_cache("in") },
  { key = "m", mods = "LEADER", action = act.ShowLauncher },
  { key = "o", mods = "LEADER", action = ws.with_cache("out") },
  { key = "p", mods = "SUPER", action = ws.with_cache("switcher") },
  { key = "P", mods = "SUPER|SHIFT", action = act.ActivateCommandPalette },
  { key = "X", mods = "LEADER", action = act.EmitEvent("smart_workspace_switcher.workspace_switcher.invalidate_cache") },
  { key = "\t", mods = "LEADER", action = ws.with_cache("prev") },

  {
    key = "W",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Foreground = { Color = theme.colors.active_fg } },
        { Text = "New workspace name:" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line then window:perform_action(
          act.SwitchToWorkspace({
            name = line,
          }),
          pane
        ) end
      end),
    }),
  },

  -- Mode
  { key = "x", mods = "LEADER", action = act.ActivateCopyMode },
  { key = " ", mods = "LEADER", action = act.QuickSelect },

  -- Paste; Cmd-v or C-a p
  { key = "p", mods = "LEADER", action = act.PasteFrom("Clipboard") },

  -- Pane Management
  { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "Q", mods = "LEADER", action = util.close_all_panes() },
  { key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "Z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "s", mods = "SUPER", action = act.PaneSelect },

  -- Navigation
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "}", mods = "LEADER", action = act.MoveTabRelative(1) },
  { key = "{", mods = "LEADER", action = act.MoveTabRelative(-1) },
  { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9", mods = "LEADER", action = act.ActivateTab(8) },
  { key = "0", mods = "LEADER", action = act.ActivateTab(-1) },
  { key = "0", mods = "SUPER", action = act.ActivateTab(-1) },

  -- Toggle raicode side panel
  { key = "r", mods = "SUPER", action = util.toggle_raicode() },

  -- Scrolling
  { key = "j", mods = "SUPER", action = act.ScrollByPage(0.5) },
  { key = "k", mods = "SUPER", action = act.ScrollByPage(-0.5) },
  { key = "J", mods = "SUPER", action = act.ScrollByPage(1) },
  { key = "K", mods = "SUPER", action = act.ScrollByPage(-1) },

  -- Launch (switch-to-or-create tab)
  { key = "a", mods = "LEADER", action = util.switch_to_tab("raicode", "raicode -c") },
  { key = "b", mods = "LEADER", action = util.switch_to_tab("repo-browse.sh") },
  { key = "e", mods = "LEADER", action = util.switch_to_tab("nvp") },
  { key = "f", mods = "LEADER", action = util.switch_to_tab("yazi") },
  { key = "g", mods = "LEADER", action = util.switch_to_tab("lazygit") },
  { key = "t", mods = "LEADER", action = util.open_daily_note() },
  { key = "u", mods = "LEADER", action = util.switch_to_tab("jjui") },
  { key = "S", mods = "LEADER", action = act.ActivateKeyTable({ name = "launch_split", one_shot = true, until_unknown = true }) },
  { key = "V", mods = "LEADER", action = act.ActivateKeyTable({ name = "launch_vertical", one_shot = true, until_unknown = true }) },

  -- Quick switch (Cmd)
  { key = "a", mods = "SUPER", action = util.switch_to_tab("raicode", "raicode -c") },
  { key = "e", mods = "SUPER", action = util.switch_to_tab("nvp") },
  { key = "g", mods = "SUPER", action = util.switch_to_tab("lazygit") },
  { key = "u", mods = "SUPER", action = util.switch_to_tab("jjui") },
}

function module.apply_to_config(config)
  config.key_tables = key_tables
  config.keys = keys
  config.leader = { key = "a", mods = "CTRL" }
end

return module
