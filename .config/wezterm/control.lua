local theme = require "theme"
local util = require "util"
local wezterm = require "wezterm"

local act = wezterm.action
local module = {}


local action_project_switcher = wezterm.action_callback(function(window, pane)
  local choices = {}
  for _, v in pairs(util.file_lines(os.getenv("HOME") .. "/.projects")) do
    table.insert(choices, { label = v })
  end

  window:perform_action(
    act.InputSelector {
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id and not label then
          wezterm.log_info "cancelled"
        else
          window:perform_action(
            act.SwitchToWorkspace {
              name = label,
              spawn = {
                cwd = label,
              },
            },
            pane
          )
        end
      end),
      fuzzy = true,
      title = "Select Project",
      choices = choices,
    },
    pane
  )
end)

local key_tables = {
  resize_pane = {
    { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
    { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
    { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
    { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
    { key = "Escape", action = "PopKeyTable" },
  },
}

local keys = {
  { key = "a",  mods = "LEADER|CTRL", action = act.SendString "\x01" },

  -- Workpace and Pallette
  { key = "d",  mods = "LEADER",      action = act.SwitchToWorkspace { name = "default" } },
  { key = "m",  mods = "LEADER",      action = act.ShowLauncher },
  { key = "p",  mods = "SUPER",       action = action_project_switcher, },
  { key = "P",  mods = "LEADER",      action = action_project_switcher, },
  { key = "P",  mods = "SUPER|SHIFT", action = act.ActivateCommandPalette },
  { key = "\t", mods = "LEADER",      action = act.SwitchWorkspaceRelative(1) },

  {
    key = "W",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = wezterm.format {
        { Foreground = { Color = theme.colors.active_fg } },
        { Text = "New workspace name:" },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },

  -- Mode
  { key = "x", mods = "LEADER", action = act.ActivateCopyMode },
  { key = " ", mods = "LEADER", action = act.QuickSelect },

  -- Paste; Cmd-v or C-a p
  { key = "p", mods = "LEADER", action = act.PasteFrom "Clipboard" },

  -- Pane Management
  { key = "s", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "v", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "w", mods = "LEADER", action = act.CloseCurrentPane { confirm = false } },
  { key = "H", mods = "LEADER", action = act.AdjustPaneSize { "Left", 5 } },
  { key = "J", mods = "LEADER", action = act.AdjustPaneSize { "Down", 5 } },
  { key = "K", mods = "LEADER", action = act.AdjustPaneSize { "Up", 5 } },
  { key = "L", mods = "LEADER", action = act.AdjustPaneSize { "Right", 5 } },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "Z", mods = "LEADER", action = act.TogglePaneZoomState },

  -- Navigation
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection "Left" },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection "Right" },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection "Up" },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection "Down" },
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
  { key = "0", mods = "SUPER",  action = act.ActivateTab(-1) },
}

function module.apply_to_config(config)
  config.key_tables = key_tables
  config.keys = keys
  config.leader = { key = "a", mods = "CTRL" }
end

return module
