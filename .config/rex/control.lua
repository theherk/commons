-- Keys, modes, and the pane and tab actions they run.
-- zellij modes are Rex key modes: pane (ctrl+p), tab (ctrl+a), session
-- (ctrl+o), resize (ctrl+shift+r). zellij scroll mode (ctrl+s) is Rex copy mode.
local util = require("util")

local module = {}

-- Mode plumbing

rex.action({
  name = "then_normal",
  title = "Run an action and return to normal mode",
  args = { action = "string", args = "object?" },
  run = function(ctx, args)
    rex.client.queue(args.action, args.args or {})
    rex.client.queue("client.mode.exit_all")
  end,
})

rex.action({
  name = "switch_mode",
  title = "Switch to Key Mode",
  args = { name = "string" },
  run = function(ctx, args)
    rex.client.queue("client.mode.exit_all")
    rex.client.queue("client.mode.enter", { name = args.name })
  end,
})

-- Panes

rex.action({
  name = "split_run",
  title = "Run Command in Split to the Right",
  args = { command = "array" },
  run = function(ctx, args)
    local _, err = rex.session.new_split({
      direction = "horizontal",
      side = "after",
      focus = true,
      layout = util.terminal_block(args.command, util.pane_cwd()),
    })
    if err then error(err, 0) end
    rex.client.queue("client.mode.exit_all")
  end,
})

rex.action({
  name = "float_run",
  title = "Run Command in Floating Pane",
  args = { command = "array", width = "number?", height = "number?" },
  run = function(ctx, args)
    local w, h = args.width or 0.5, args.height or 0.5
    local _, err = rex.session.new_layer({
      bounds = { (1 - w) / 2, (1 - h) / 2, w, h },
      focus = true,
      layout = util.terminal_block(args.command, util.pane_cwd()),
    })
    if err then error(err, 0) end
  end,
})

rex.action({
  name = "pane_swap",
  title = "Swap Pane with Next or Previous",
  args = { direction = "string" },
  run = function(ctx, args)
    local view, err = rex.session.view({})
    if not view then error(err, 0) end
    for _, win in ipairs(view.windows or {}) do
      if win.window_id == view.active_window_id then
        local blocks = (win.layers and win.layers[1] and win.layers[1].blocks) or {}
        local n = #blocks
        for i, b in ipairs(blocks) do
          if b.block_id == win.focused_block_id and n > 1 then
            local j = args.direction == "previous" and i - 1 or i + 1
            j = ((j - 1) % n) + 1
            rex.session.swap_blocks({ block_id = b.block_id, other_block_id = blocks[j].block_id })
            break
          end
        end
      end
    end
    rex.client.queue("client.mode.exit_all")
  end,
})

-- Tabs

-- Replaces zellij-tab-switcher.wasm: show the tab with this label, or open it.
-- The app chooses which tab it shows; client.tab.goto counts every tab in the
-- sidebar, so name the session and window instead.
local function goto_window(ctx, window_id)
  rex.client.queue("session.select", { session_id = ctx.session_id, window_id = window_id })
end

rex.action({
  name = "tab_open",
  title = "Go to or Open Named Tab",
  args = { name = "string", command = "array?" },
  run = function(ctx, args)
    rex.client.queue("client.mode.exit_all")
    local view, err = rex.session.view({})
    if not view then error(err, 0) end
    for _, win in ipairs(view.windows or {}) do
      if win.label == args.name then
        goto_window(ctx, win.window_id)
        return
      end
    end
    local w, nerr = rex.session.new_window({
      window_label = args.name,
      focus = true,
      layout = util.terminal_block(args.command, util.workspace_root()),
    })
    if not w then error(nerr, 0) end
    -- The app fetches the new view after the window is created; a select
    -- that arrives first is ignored. Wait about one fetch, no longer.
    rex.exec({ "/bin/sleep", "0.06" })
    goto_window(ctx, w.window_id)
  end,
})

-- Normal mode (no Rex mode active)

rex.bind("cmd+s", "client.sidebar.toggle")
rex.bind("ctrl+a", "client.mode.enter", { name = "tab" })
rex.bind("ctrl+p", "client.mode.enter", { name = "pane" })
rex.bind("ctrl+o", "client.mode.enter", { name = "session", once = true })
rex.bind("ctrl+shift+r", "client.mode.enter", { name = "resize" })
rex.bind("ctrl+s", "pane.copy_mode.enter")

-- zellij shared_except "locked": ctrl+a switches to tab mode from any mode.
for _, mode in ipairs({ "pane", "tab", "session", "resize" }) do
  rex.bind(mode .. "/ctrl+a", "switch_mode", { name = "tab" })
end

-- Pane mode

rex.mode("pane", { exclusive = true })
rex.bind("pane/e", "split_run", { command = { "nvp" } })
rex.bind("pane/f", "split_run", { command = { "fish", "-c", "yazi" } })
rex.bind("pane/g", "split_run", { command = { "lazygit" } })
rex.bind("pane/r", "review_open")
rex.bind("pane/s", "then_normal", { action = "pane.split", args = { direction = "down" } })
rex.bind("pane/u", "split_run", { command = { "jjui" } })
rex.bind("pane/v", "then_normal", { action = "pane.split", args = { direction = "right" } })
rex.bind("pane/[", "then_normal", { action = "pane.focus_previous" })
rex.bind("pane/]", "then_normal", { action = "pane.focus_next" })
rex.bind("pane/shift+h", "pane.move", { direction = "left" })
rex.bind("pane/shift+j", "pane.move", { direction = "down" })
rex.bind("pane/shift+k", "pane.move", { direction = "up" })
rex.bind("pane/shift+l", "pane.move", { direction = "right" })
rex.bind("pane/shift+[", "pane_swap", { direction = "previous" })
rex.bind("pane/shift+]", "pane_swap", { direction = "next" })

-- Tab mode

rex.mode("tab", { exclusive = true })
rex.bind("tab/a", "tab_open", { name = "agent", command = { "opencode", "-c" } })
rex.bind("tab/m", "tab_open", { name = "main" })
rex.bind("tab/e", "tab_open", { name = "editor", command = { "nvp" } })
rex.bind("tab/f", "tab_open", { name = "files", command = { "fish", "-c", "yazi" } })
rex.bind("tab/g", "tab_open", { name = "git", command = { "lazygit" } })
rex.bind("tab/r", "review_open", { tab = true })
rex.bind("tab/u", "tab_open", { name = "jj", command = { "jjui" } })
rex.bind("tab/n", "then_normal", { action = "client.tab.new" })
rex.bind("tab/[", "then_normal", { action = "client.tab.previous" })
rex.bind("tab/]", "then_normal", { action = "client.tab.next" })
rex.bind("tab/shift+h", "client.tab.move", { direction = "backward" })
rex.bind("tab/shift+l", "client.tab.move", { direction = "forward" })
rex.bind("tab/shift+[", "then_normal", { action = "client.tab.move", args = { direction = "backward" } })
rex.bind("tab/shift+]", "then_normal", { action = "client.tab.move", args = { direction = "forward" } })

-- Session mode (every binding leaves the mode, so it is entered with once)

rex.mode("session", { exclusive = true })
rex.bind("session/o", "repo_open")
rex.bind("session/a", "repo_open", { actions = true })
rex.bind("session/b", "float_run", { command = { "repo-browse.sh" } })
rex.bind("session/shift+b", "float_run", { command = { "repo-browse.sh", "actions" } })
rex.bind("session/k", "project_kill")
rex.bind("session/shift+k", "project_kill", { all = true })
rex.bind("session/p", "project_switch")
rex.bind("session/r", "project_switch", { active = true })
rex.bind("session/t", "float_run", { command = { "obsidian-daily.sh" }, width = 0.73, height = 0.81 })
rex.bind("session/y", "project_copy")

-- Resize mode

rex.mode("resize", { exclusive = true })
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("resize/" .. key, "pane.resize", { direction = direction })
  rex.bind("resize/" .. direction, "pane.resize", { direction = direction })
end

return module
