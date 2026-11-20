local module = {}

module.TERMINAL = "com.superlogical.terminal"
module.SHELL = "com.superlogical.terminal.shell"
module.HOME = os.getenv("HOME") or ""

-- The server starts with a bare system PATH; borrow the login shell's.
local PATH = (function()
  local login = os.getenv("SHELL") or "/bin/zsh"
  local r = rex.exec({ login, "-l", "-c", "/usr/bin/printenv PATH" }, { timeout = 5 })
  if r and r.ok and r.stdout ~= "" then
    return (r.stdout:gsub("%s+$", ""))
  end
  local home = module.HOME
  return table.concat({ home .. "/bin", "/opt/homebrew/bin", "/usr/local/bin", "/usr/bin", "/bin", "/usr/sbin", "/sbin" }, ":")
end)()

function module.run(argv, opts)
  opts = opts or {}
  opts.env = opts.env or {}
  opts.env.PATH = PATH
  return rex.exec(argv, opts)
end

function module.basename(path)
  local trimmed = path:gsub("/+$", "")
  return trimmed:match("([^/]+)$") or trimmed
end

function module.tilde(path)
  local home = module.HOME
  if path:sub(1, #home + 1) == home .. "/" then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

function module.pane_cwd()
  local p = rex.block.call(module.TERMINAL, "process", {})
  if p and p.foreground and p.foreground.cwd then return p.foreground.cwd end
  local r = rex.block.call(module.TERMINAL, "pwd", {})
  local pwd = r and r.pwd
  if not pwd then return nil end
  pwd = pwd:gsub("^file://[^/]*", "")
  pwd = pwd:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
  return pwd
end

-- The jj or git root of the focused pane's directory, or that directory.
function module.workspace_root()
  local cwd = module.pane_cwd()
  if not cwd then return nil end
  for _, argv in ipairs({ { "jj", "root" }, { "git", "rev-parse", "--show-toplevel" } }) do
    local r = module.run(argv, { cwd = cwd })
    if r and r.ok and r.stdout ~= "" then return (r.stdout:gsub("%s+$", "")) end
  end
  return cwd
end

function module.terminal_block(command, cwd)
  local options = { cwd = cwd }
  if command and #command > 0 then options.command = command end
  return rex.layout.block({ flavor = module.SHELL, options = options })
end

return module
