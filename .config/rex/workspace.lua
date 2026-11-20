-- Sessions and projects (replaces zellij-project.fish and zellij-prune-sessions.fish).
local util = require("util")

local module = {}

-- Project directories, ranked as `zoxide query -l | projects-rank.sh` does.
local function projects()
  local r = util.run({ "sh", "-c", "zoxide query -l | projects-rank.sh" })
  local list = {}
  if r and r.ok then
    for line in r.stdout:gmatch("[^\n]+") do list[#list + 1] = line end
  end
  return list
end

local function sessions()
  local r, err = rex.call("session.list")
  if not r then error(err, 0) end
  return r.sessions or {}
end

-- A session runs nvim when a project named like it has a _neovim socket.
local function has_nvim(label, repos)
  for _, dir in ipairs(repos) do
    if util.basename(dir) == label then
      local r = util.run({ "test", "-S", dir .. "/_neovim" })
      if r and r.ok then return true end
    end
  end
  return false
end

local function killable_sessions(ctx)
  local repos = projects()
  local out = {}
  for _, s in ipairs(sessions()) do
    if s.session_id ~= ctx.session_id and not has_nvim(s.label, repos) then
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
    local items = {}
    for _, s in ipairs(all) do
      if s.session_id ~= ctx.session_id then
        items[#items + 1] = {
          id = s.session_id,
          title = s.label,
          icon = "terminal",
          detail = has_nvim(s.label, repos) and "nvim" or nil,
        }
      end
    end
    table.sort(items, function(a, b) return a.title < b.title end)
    if not args.active then
      for _, dir in ipairs(repos) do
        if not by_label[util.basename(dir)] then
          items[#items + 1] = { id = dir, title = util.basename(dir), subtitle = util.tilde(dir), icon = "folder" }
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

    local name = util.basename(choice)
    if name == current then return end
    if by_label[name] then
      rex.client.queue("session.select", { session_id = by_label[name].session_id })
      return
    end
    local s, err = rex.call("session.create", {
      label = name,
      initial_windows = { { window_label = "main", layout = util.terminal_block(nil, choice) } },
    })
    if not s then error(err, 0) end
    rex.client.queue("session.select", { session_id = s.session_id })
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
    for _, dir in ipairs(projects()) do
      items[#items + 1] = { id = dir, title = util.tilde(dir), icon = "folder" }
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

return module
