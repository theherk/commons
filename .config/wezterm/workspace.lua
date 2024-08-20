local theme = require("theme")
local wezterm = require("wezterm")

local act = wezterm.action
local module = {}

local rg_pipe = " | rg --color=never -FxNf ~/.projects"
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local prev_pos = 1
local stack = { "default" }
local stack_pos = 1

module.with_cache = function(dest)
  if dest == "default" then
    return wezterm.action_callback(function(window, pane) window:perform_action(act.EmitEvent("stack-default"), pane) end)
  elseif dest == "in" then
    return wezterm.action_callback(function(window, pane) window:perform_action(act.EmitEvent("stack-in"), pane) end)
  elseif dest == "out" then
    return wezterm.action_callback(function(window, pane) window:perform_action(act.EmitEvent("stack-out"), pane) end)
  elseif dest == "prev" then
    return wezterm.action_callback(function(window, pane) window:perform_action(act.EmitEvent("stack-prev"), pane) end)
  elseif dest == "switcher" then
    return wezterm.action_callback(function(window, pane) window:perform_action(act.EmitEvent("stack-switcher"), pane) end)
  else
    return wezterm.action_callback(function(window, pane) window:perform_action(act.Nop, pane) end)
  end
end

local stack_insert = function()
  for i, _ in ipairs(stack) do
    if i > stack_pos then table.remove(stack, i) end
  end
  if wezterm.mux.get_active_workspace() ~= stack[stack_pos] then
    prev_pos = stack_pos
    table.insert(stack, wezterm.mux.get_active_workspace())
  end
  stack_pos = #stack
end

local stack_log = function()
  wezterm.log_debug("stack: " .. table.concat(stack))
  wezterm.log_debug("stack_pos: " .. stack_pos)
  wezterm.log_info("workspace: " .. wezterm.mux.get_active_workspace())
end

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", stack_insert)
wezterm.on("smart_workspace_switcher.workspace_switcher.created", stack_insert)

wezterm.on("stack-default", function(window, pane)
  if wezterm.mux.get_active_workspace() ~= "default" then window:perform_action(
    act.Multiple({
      act.SwitchToWorkspace({ name = "default" }),
      act.EmitEvent("stack-insert"),
    }),
    pane
  ) end
end)

wezterm.on("stack-log", function() stack_log() end)

wezterm.on("stack-in", function(window, pane)
  if stack_pos < #stack then
    prev_pos = stack_pos
    stack_pos = stack_pos + 1
    window:perform_action(act.SwitchToWorkspace({ name = stack[stack_pos] }), pane)
  end
end)

wezterm.on("stack-insert", function() stack_insert() end)

wezterm.on("stack-out", function(window, pane)
  if stack_pos ~= 1 then
    prev_pos = stack_pos
    stack_pos = stack_pos - 1
    window:perform_action(act.SwitchToWorkspace({ name = stack[stack_pos] }), pane)
  end
end)

wezterm.on("stack-prev", function(window, pane)
  local target_pos = prev_pos
  prev_pos = stack_pos
  stack_pos = target_pos
  window:perform_action(act.SwitchToWorkspace({ name = stack[target_pos] }), pane)
end)

wezterm.on("stack-switcher", function(window, pane) window:perform_action(workspace_switcher.switch_workspace(rg_pipe), pane) end)

workspace_switcher.set_workspace_formatter(function(label)
  return wezterm.format({
    { Attribute = { Italic = true } },
    { Foreground = { Color = theme.colors.hl_1 } },
    { Text = "󱂬 " .. label },
  })
end)

return module
