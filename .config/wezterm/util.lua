local wezterm = require("wezterm")
local theme = require("theme")

local module = {}

local function base_path_name(str) return string.gsub(str, "(.*[/\\])(.*)", "%2") end

function module.file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function module.file_lines(file)
  if not module.file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

function module.format_tab_title(tab, tabs, panes, config, hover, max_width)
  local label = {
    { Foreground = { Color = theme.colors.hl_1 } },
    { Text = " " .. tab.tab_index + 1 },
    { Foreground = { Color = theme.colors.hl_2 } },
    { Text = ": " },
  }
  local pane = tab.active_pane
  if pane.is_zoomed then module.tconcat(label, {
    { Text = "🔍 " },
  }) end
  local title = tab.active_pane.title
  if tab.tab_title ~= "" then title = tab.tab_title end
  if tab.is_active then
    module.tconcat(label, {
      { Foreground = { Color = theme.colors.active_fg } },
      { Text = title .. " " },
    })
  else
    module.tconcat(label, {
      { Foreground = { Color = theme.colors.inactive_fg } },
      { Text = title .. " " },
    })
  end
  module.tconcat(label, {
    -- { Background = { Color=C_BG } },
    { Background = { Color = "none" } },
    { Foreground = { Color = theme.colors.hl_1 } },
    { Text = "|" },
  })
  return label
end

function module.launch(args)
  return wezterm.action_callback(function(window, _)
    local tab, pane, _ = window:mux_window():spawn_tab({
      args = { os.getenv("SHELL"), "-c", table.unpack(args) },
    })
    tab:set_title(args[1])
  end)
end

function module.tconcat(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

function module.update_right_status(window, pane)
  local text = {
    { Attribute = { Italic = true } },
    { Foreground = { Color = theme.colors.hl_1 } },
    { Text = "󱂬  " },
    { Foreground = { Color = theme.colors.hl_2 } },
    { Text = base_path_name(window:active_workspace()) },
  }
  if window:active_key_table() then
    module.tconcat(text, {
      { Foreground = { Color = theme.colors.hl_1 } },
      { Text = " | ⌨ " },
      { Foreground = { Color = theme.colors.hl_2 } },
      { Text = window:active_key_table() },
    })
  end
  local tab = pane:tab()
  if tab == nil then return end
  for _, p in ipairs(tab:panes_with_info()) do
    -- wezterm.log_info("zoomed: " .. tostring(p.is_zoomed))
    if p.is_zoomed then module.tconcat(text, {
      { Text = " 🔍" },
    }) end
  end
  module.tconcat(text, {
    { Text = " " },
  })
  window:set_right_status(wezterm.format(text))
end

function module.user_var_changed(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end

return module
