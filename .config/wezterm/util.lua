local wezterm = require("wezterm")
local theme = require("theme")

local act = wezterm.action
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
    { Background = { Color = theme.colors.bg } },
    { Foreground = { Color = theme.colors.hl_1 } },
    { Text = "|" },
  })
  return label
end

function module.launch(args)
  return wezterm.action_callback(function(window, _)
    local _, _, _ = window:mux_window():spawn_tab({
      args = { os.getenv("SHELL"), "-l", "-c", module.titled_cmd(args) },
    })
  end)
end

--- Launches new split pane but with spawn command.
--- Yes, this seems backward, but Wezterm refers to the direction splitting
--- rather than the layout of the newly launched pane.
function module.launch_split(args)
  return act.SplitVertical({
    args = { os.getenv("SHELL"), "-c", table.unpack(args) },
    domain = "CurrentPaneDomain",
  })
end

--- Launches new vertical but with spawn command.
--- Yes, this seems backward, but Wezterm refers to the direction splitting
--- rather than the layout of the newly launched pane.
function module.launch_vertical(args)
  return act.SplitHorizontal({
    args = { os.getenv("SHELL"), "-c", table.unpack(args) },
    domain = "CurrentPaneDomain",
  })
end

function module.tconcat(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

function module.titled_cmd(args)
  local title = args[1]
  return string.format("wezterm cli set-tab-title %s && %s", title, table.concat(args, " "))
end

function module.update_right_status(window, pane)
  local ok, _ = pcall(function()
    local text = {}
    module.tconcat(text, {
      { Attribute = { Italic = true } },
      { Foreground = { Color = theme.colors.hl_1 } },
      { Text = "󱂬  " },
      { Foreground = { Color = theme.colors.hl_2 } },
      { Text = base_path_name(window:active_workspace()) },
    })
    if window:active_key_table() then
      module.tconcat(text, {
        { Foreground = { Color = theme.colors.hl_1 } },
        { Text = " | ⌨ " },
        { Foreground = { Color = theme.colors.hl_2 } },
        { Text = window:active_key_table() },
      })
    end
    local tab = pane:tab()
    if tab ~= nil then
      for _, p in ipairs(tab:panes_with_info()) do
        if p.is_zoomed then module.tconcat(text, {
          { Text = " 🔍" },
        }) end
      end
    end
    module.tconcat(text, {
      { Text = " " },
    })
    window:set_right_status(wezterm.format(text))
  end)
  if not ok then
    window:set_right_status("")
  end
end

function module.toggle_raicode()
  return wezterm.action_callback(function(window, pane)
    local tab = pane:tab()
    if tab == nil then return end

    local panes = tab:panes_with_info()
    local raicode_pane = nil
    local any_zoomed = false

    for _, p in ipairs(panes) do
      if p.is_zoomed then any_zoomed = true end
      if p.pane:get_user_vars().RAICODE == "1" then raicode_pane = p end
    end

    if raicode_pane == nil then
      window:perform_action(
        act.SplitHorizontal({
          args = {
            "/opt/homebrew/bin/fish",
            "-l",
            "-c",
            "printf '\\e]1337;SetUserVar=%s=%s\\a' RAICODE (echo -n 1 | base64); raicode-select.sh",
          },
          domain = "CurrentPaneDomain",
        }),
        pane
      )
      window:perform_action(act.AdjustPaneSize({ "Left", 21 }), pane)
    elseif any_zoomed then
      -- A pane is zoomed, unzoom and focus raicode
      window:perform_action(act.TogglePaneZoomState, pane)
      window:perform_action(act.ActivatePaneByIndex(raicode_pane.index), pane)
    else
      -- Both visible, zoom the left (non-raicode) pane to hide raicode
      if raicode_pane.is_active then
        for _, p in ipairs(panes) do
          if p.index ~= raicode_pane.index then
            window:perform_action(act.ActivatePaneByIndex(p.index), pane)
            window:perform_action(act.TogglePaneZoomState, p.pane)
            break
          end
        end
      else
        window:perform_action(act.TogglePaneZoomState, pane)
      end
    end
  end)
end

function module.switch_to_tab(title, cmd)
  return wezterm.action_callback(function(window, pane)
    local mux_window = window:mux_window()
    local active_tab = pane:tab()
    for _, tab in ipairs(mux_window:tabs()) do
      if tab:get_title() == title then
        if active_tab and tab:tab_id() == active_tab:tab_id() then return end
        tab:activate()
        return
      end
    end
    local spawn_cmd = cmd or title
    mux_window:spawn_tab({
      args = { os.getenv("SHELL"), "-l", "-c", module.titled_cmd({ spawn_cmd }) },
    })
  end)
end

function module.open_daily_note()
  local ws_name = "~/vaults/brain"
  return wezterm.action_callback(function(window, pane)
    -- Find or create the workspace
    local ws_exists = false
    for _, w in ipairs(wezterm.mux.all_windows()) do
      if w:get_workspace() == ws_name then
        ws_exists = true
        break
      end
    end

    if ws_exists then
      window:perform_action(act.SwitchToWorkspace({ name = ws_name }), pane)
    else
      window:perform_action(act.SwitchToWorkspace({ name = ws_name, spawn = { cwd = wezterm.home_dir .. "/vaults/brain" } }), pane)
    end

    -- Push workspace onto the stack
    window:perform_action(act.EmitEvent("stack-insert"), pane)

    -- After switch settles, find or create the nvp tab and run :Obsidian today
    wezterm.time.call_after(0.1, function()
      local mux_window = nil
      for _, w in ipairs(wezterm.mux.all_windows()) do
        if w:get_workspace() == ws_name then
          mux_window = w
          break
        end
      end
      if mux_window == nil then return end

      local nvp_tab = nil
      for _, tab in ipairs(mux_window:tabs()) do
        if tab:get_title() == "nvp" then
          nvp_tab = tab
          break
        end
      end

      if nvp_tab then
        nvp_tab:activate()
        nvp_tab:active_pane():send_text(":Obsidian today\r")
      else
        local cmd = "wezterm cli set-tab-title nvp && nvp '+lua vim.defer_fn(function() vim.cmd(\"Obsidian today\") end, 500)'"
        mux_window:spawn_tab({ args = { os.getenv("SHELL"), "-l", "-c", cmd } })
      end
    end)
  end)
end

function module.close_all_panes()
  local shells = { fish = true, zsh = true, bash = true }
  return wezterm.action_callback(function(window, _)
    for _, mux_win in ipairs(wezterm.mux.all_windows()) do
      for _, tab in ipairs(mux_win:tabs()) do
        for _, p in ipairs(tab:panes()) do
          local title = p:get_title() or ""
          if shells[title] then
            p:send_text("exit\r")
          else
            p:send_text("\x03")
            local cwd = p:get_current_working_dir()
            if cwd then
              local dir = cwd.file_path or cwd:gsub("^file://[^/]*", "")
              wezterm.background_child_process({
                "/opt/homebrew/bin/nvim",
                "--server", dir .. "/_neovim",
                "--remote-send", "<Cmd>qall!<CR>",
              })
            end
          end
        end
      end
    end
    wezterm.time.call_after(0.5, function()
      for _, mux_win in ipairs(wezterm.mux.all_windows()) do
        for _, tab in ipairs(mux_win:tabs()) do
          for _, p in ipairs(tab:panes()) do
            local title = p:get_title() or ""
            if shells[title] then
              p:send_text("exit\r")
            end
          end
        end
      end
    end)
  end)
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
