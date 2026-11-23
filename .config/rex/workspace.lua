-- Sessions and projects (replaces zellij-project.fish and zellij-prune-sessions.fish).
local util = require("util")

local module = {}

-- Projects, ranked by zop. Each has a path and an id; the id names the session.
local function projects()
  local r = util.run({ "zop", "list", "--json", "--no-tilde" })
  local list = {}
  if r and r.ok then
    local doc = rex.json.decode(r.stdout)
    for _, p in ipairs(doc.projects or {}) do
      list[#list + 1] = { path = p.path, id = p.id }
    end
  end
  return list
end

local function sessions()
  local r, err = rex.call("session.list")
  if not r then error(err, 0) end
  return r.sessions or {}
end

-- Labels of the sessions whose project has a live nvim, from one zop call.
local function nvim_labels()
  local r = util.run({ "zop", "list", "--json", "--no-tilde", "--live", "nvim.sock" })
  local set = {}
  if r and r.ok then
    for _, p in ipairs(rex.json.decode(r.stdout).projects or {}) do set[p.id] = true end
  end
  return set
end

local function killable_sessions(ctx)
  local live = nvim_labels()
  local out = {}
  for _, s in ipairs(sessions()) do
    if s.session_id ~= ctx.session_id and not live[s.label] then
      out[#out + 1] = s
    end
  end
  table.sort(out, function(a, b) return a.label < b.label end)
  return out
end

rex.action({
  name = "project_switch",
  title = "Switch to Project Session…",
  args = { active = "boolean?" },
  run = function(ctx, args)
    local all, by_label, current = sessions(), {}, nil
    for _, s in ipairs(all) do
      by_label[s.label] = s
      if s.session_id == ctx.session_id then current = s.label end
    end

    local repos = projects()
    local live = nvim_labels()
    local items = {}
    for _, s in ipairs(all) do
      if s.session_id ~= ctx.session_id then
        items[#items + 1] = {
          id = s.session_id,
          title = s.label,
          icon = "terminal",
          detail = live[s.label] and "nvim" or nil,
        }
      end
    end
    table.sort(items, function(a, b) return a.title < b.title end)
    if not args.active then
      for _, p in ipairs(repos) do
        if not by_label[p.id] then
          items[#items + 1] = { id = p.path, title = p.id, subtitle = util.tilde(p.path), icon = "folder" }
        end
      end
    end

    local choice = rex.ui.pick({
      title = args.active and "Switch session" or "Open project",
      placeholder = "Filter",
      items = items,
    })
    if choice == nil then return end

    if choice:sub(1, 1) ~= "/" then
      rex.client.queue("session.select", { session_id = choice })
      return
    end

    local name
    for _, p in ipairs(repos) do
      if p.path == choice then name = p.id break end
    end
    name = name or util.basename(choice)
    if name == current then return end
    if by_label[name] then
      rex.client.queue("session.select", { session_id = by_label[name].session_id })
      util.run({ "zop", "visit", choice })
      return
    end
    local s, err = rex.call("session.create", {
      label = name,
      initial_windows = { { window_label = "main", layout = util.terminal_block(nil, choice) } },
    })
    if not s then error(err, 0) end
    rex.client.queue("session.select", { session_id = s.session_id })
    util.run({ "zop", "visit", choice })
  end,
})

rex.action({
  name = "project_kill",
  title = "Kill Sessions Without nvim…",
  args = { all = "boolean?" },
  run = function(ctx, args)
    local candidates = killable_sessions(ctx)
    if #candidates == 0 then return "No killable sessions." end

    local ids = {}
    if args.all then
      for _, s in ipairs(candidates) do ids[#ids + 1] = s.session_id end
    else
      local items = {}
      for _, s in ipairs(candidates) do
        items[#items + 1] = { id = s.session_id, title = s.label, icon = "terminal" }
      end
      ids = rex.ui.pick({ title = "Select sessions to kill", items = items, multiple = true, confirm = "Kill" })
      if ids == nil then return end
    end

    for _, id in ipairs(ids) do rex.call("session.destroy", { session_id = id }) end
    return string.format("Killed %d session(s).", #ids)
  end,
})

rex.action({
  name = "project_copy",
  title = "Copy Project Path…",
  run = function(ctx, args)
    local items = {}
    for _, p in ipairs(projects()) do
      items[#items + 1] = { id = p.path, title = util.tilde(p.path), icon = "folder" }
    end
    local dir = rex.ui.pick({ title = "Copy project path", items = items })
    if dir == nil then return end
    util.run({ "pbcopy" }, { stdin = dir })
    return "Copied: " .. dir
  end,
})

rex.action({
  name = "repo_open",
  title = "Open Repository in Browser",
  args = { actions = "boolean?" },
  run = function(ctx, args)
    local argv = { "repo-open.sh" }
    if args.actions then argv[2] = "actions" end
    local r, err = util.run(argv, { cwd = util.pane_cwd() })
    if not r then error(err, 0) end
    if not r.ok then error(r.stderr, 0) end
  end,
})

-- Pick an opencode session of the focused pane's repository and review its
-- changes with oc-review, in a split or a "review" tab.
rex.action({
  name = "review_open",
  title = "Review Changes for an opencode Session…",
  args = { tab = "boolean?" },
  run = function(ctx, args)
    rex.client.queue("client.mode.exit_all")
    local root = util.workspace_root()
    if not root then error("No working directory for the focused pane.", 0) end

    local r = util.run({ "opencode", "api", "get", "/api/session", "--param", "limit=100" }, { timeout = 10 })
    if not (r and r.ok) then error("opencode api: " .. ((r and r.stderr) or "failed"), 0) end
    local items = {}
    for _, s in ipairs(rex.json.decode(r.stdout).data or {}) do
      if s.parentID == nil and s.location and s.location.directory == root then
        items[#items + 1] = { id = s.id, title = s.title, subtitle = s.id, icon = "terminal" }
      end
    end
    if #items == 0 then return "No opencode sessions in " .. util.tilde(root) end

    local id = items[1].id
    if #items > 1 then
      id = rex.ui.pick({ title = "Review for session", placeholder = "Filter", items = items })
      if id == nil then return end
    end

    local layout = util.terminal_block({ "oc-review", "-s", id }, root)
    if args.tab then
      local w, err = rex.session.new_window({ window_label = "review", focus = true, layout = layout })
      if not w then error(err, 0) end
      rex.exec({ "/bin/sleep", "0.06" })
      rex.client.queue("session.select", { session_id = ctx.session_id, window_id = w.window_id })
    else
      local _, err = rex.session.new_split({ direction = "horizontal", side = "after", focus = true, layout = layout })
      if err then error(err, 0) end
    end
  end,
})

return module
