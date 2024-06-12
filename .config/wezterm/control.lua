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

  launch = {
    { key = "s", action = act.ActivateKeyTable({ name = "launch_split", one_shot = true, until_unknown = true }) },
    { key = "t", action = act.ActivateKeyTable({ name = "launch_tab", one_shot = true, until_unknown = true }) },
    { key = "v", action = act.ActivateKeyTable({ name = "launch_vertical", one_shot = true, until_unknown = true }) },
    { key = "Escape", action = "PopKeyTable" },
  },

  launch_split = {
    { key = "f", action = util.launch_split({ "yazi" }) },
    { key = "F", action = util.launch_split({ "xplr" }) },
    { key = "g", action = util.launch_split({ "lazygit" }) },
    { key = "Escape", action = "PopKeyTable" },
  },

  launch_tab = {
    { key = "f", action = util.launch({ "yazi" }) },
    { key = "F", action = util.launch({ "xplr" }) },
    { key = "g", action = util.launch({ "lazygit" }) },
    { key = "Escape", action = "PopKeyTable" },
  },

  launch_vertical = {
    { key = "f", action = util.launch_vertical({ "yazi" }) },
    { key = "F", action = util.launch_vertical({ "xplr" }) },
    { key = "g", action = util.launch_vertical({ "lazygit" }) },
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

  -- Workpace and Pallette
  { key = "d", mods = "LEADER", action = ws.with_cache("default") },
  { key = "i", mods = "LEADER", action = ws.with_cache("in") },
  { key = "m", mods = "LEADER", action = act.ShowLauncher },
  { key = "o", mods = "LEADER", action = ws.with_cache("out") },
  { key = "p", mods = "SUPER", action = ws.with_cache("switcher") },
  { key = "P", mods = "SUPER|SHIFT", action = act.ActivateCommandPalette },
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
  { key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "Z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "S", mods = "LEADER", action = act.PaneSelect },

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

  -- Scrolling
  { key = "j", mods = "SUPER", action = act.ScrollByPage(0.5) },
  { key = "k", mods = "SUPER", action = act.ScrollByPage(-0.5) },
  { key = "J", mods = "SUPER", action = act.ScrollByPage(1) },
  { key = "K", mods = "SUPER", action = act.ScrollByPage(-1) },

  -- Launch
  { key = "l", mods = "LEADER", action = act.ActivateKeyTable({ name = "launch", one_shot = true, until_unknown = true }) },
  { key = "e", mods = "LEADER", action = util.launch({ "editor" }) },
  { key = "f", mods = "LEADER", action = util.launch({ "yazi" }) },
  { key = "F", mods = "LEADER", action = util.launch({ "xplr" }) },
  { key = "g", mods = "LEADER", action = util.launch({ "lazygit" }) },
}

function module.apply_to_config(config)
  config.key_tables = key_tables
  config.keys = keys
  config.leader = { key = "a", mods = "CTRL" }
end

return module
