local wezterm = require "wezterm";
local act = wezterm.action

local selected_scheme = "tokyonight_night";
local scheme = wezterm.get_builtin_color_schemes()[selected_scheme]

local C_ACTIVE_BG = scheme.selection_bg;
local C_ACTIVE_FG = scheme.ansi[6];
local C_BG = scheme.background;
local C_HL_1 = scheme.ansi[5];
local C_HL_2 = scheme.ansi[4];
local C_INACTIVE_FG;
local C_PANEL_BG;
local bg = wezterm.color.parse(scheme.background);
local _, _, l, _ = bg:hsla();
if l > 0.5 then
  C_INACTIVE_FG = bg:complement_ryb():darken(0.3);
  C_PANEL_BG = bg:darken(0.1);
else
  C_INACTIVE_FG = bg:complement_ryb():lighten(0.3);
  C_PANEL_BG = bg:lighten(0.1);
end

local function tconcat(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
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

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    local title = {
      { Foreground = { Color = C_HL_1 } },
      { Text = " " .. tab.tab_index + 1 },
      { Foreground = { Color = C_HL_2 } },
      { Text = ": " },
    }
    if tab.is_active then
      tconcat(title, {
        { Foreground = { Color = C_ACTIVE_FG } },
        { Text = tab.active_pane.title .. " " },
      })
    else
      tconcat(title, {
        { Foreground = { Color = C_INACTIVE_FG } },
        { Text = tab.active_pane.title .. " " },
      })
    end
    local pane = tab.active_pane
    if pane.is_zoomed then
      tconcat(title, {
        { Text = "🔍 " },
      })
    end
    tconcat(title, {
      -- { Background = { Color=C_BG } },
      { Background = { Color = "none" } },
      { Foreground = { Color = C_HL_1 } },
      { Text = "|" },
    })
    return title
  end
)

wezterm.on(
  "update-right-status",
  function(window, pane)
    local text = {}
    if window:active_key_table() then
      tconcat(text, {
        { Foreground = { Color = C_HL_1 } },
        { Text = " TABLE: " },
        { Foreground = { Color = C_HL_2 } },
        { Text = window:active_key_table() },
      })
    end
    local tab = pane:tab()
    for _, p in ipairs(tab:panes_with_info()) do
      wezterm.log_info("zoomed: " .. tostring(p.is_zoomed))
      if p.is_zoomed then
        tconcat(text, {
          { Text = " 🔍" },
        })
      end
    end
    tconcat(text, {
      { Text = " " },
    })
    window:set_right_status(wezterm.format(text))
  end
)

return {
  leader = { key = "a", mods = "CTRL" },
  check_for_updates = false,
  command_palette_font_size = 24,
  command_palette_bg_color = C_PANEL_BG,
  command_palette_fg_color = C_ACTIVE_FG,
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
      { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
      { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
      { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
      { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
      { key = "Escape", action = "PopKeyTable" },
    },
  },
  keys = {
    { key = "a",  mods = "LEADER|CTRL", action = act.SendString "\x01" },

    -- Workpace and Pallette
    { key = "m",  mods = "LEADER",      action = act.ShowLauncher },
    { key = "P",  mods = "SUPER|SHIFT", action = act.ActivateCommandPalette },
    { key = "\t", mods = "LEADER",      action = act.SwitchWorkspaceRelative(1) },

    {
      key = "W",
      mods = "LEADER",
      action = act.PromptInputLine {
        description = wezterm.format {
          { Foreground = { Color = C_ACTIVE_FG } },
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
  },
}
