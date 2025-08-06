local M = {}

M.root_patterns = { ".git", "lua" }

function M.get_active_sources()
  local sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }
  return sources
end

function M.fg(name)
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

function M.get_clients(opts)
  local ret = {}
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then ret = vim.tbl_filter(function(client) return client.supports_method(opts.method, { bufnr = opts.bufnr }) end, ret) end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(M.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  table.sort(roots, function(a, b) return #a > #b end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- Update guifont, by getting current font and size, adding x, then setting
-- the font to the same font but the updated size.
function M.increment_font(x)
  local font = vim.o.guifont
  -- Match font name and size (assumes format "FontName:h{size}")
  local font_name, size = font:match("(.+):h(%d+)")
  if font_name and size then
    size = tonumber(size) + x
    size = math.max(6, size) -- Ensure minimum size of 6
    vim.o.guifont = string.format("%s:h%d", font_name, size)
  end
end

function M.lines(fname)
  local lines = {}
  for line in io.lines(fname) do
    table.insert(lines, line)
  end
  return lines
end

function M.set_cursor_colors(colors)
  vim.api.nvim_set_hl(0, "Cursor", { bg = colors.blue, fg = "black" })
  vim.api.nvim_set_hl(0, "TermCursor", { bg = colors.blue, fg = "black" })
end

-- This is bespoke to catppuccin at the moment, but should be expanded.
function M.set_term_colors(colors)
  vim.g.terminal_color_0 = colors.surface1
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_5 = colors.pink
  vim.g.terminal_color_6 = colors.teal
  vim.g.terminal_color_7 = colors.subtext1
  vim.g.terminal_color_8 = colors.surface2
  vim.g.terminal_color_9 = colors.red
  vim.g.terminal_color_10 = colors.green
  vim.g.terminal_color_11 = colors.yellow
  vim.g.terminal_color_12 = colors.blue
  vim.g.terminal_color_13 = colors.pink
  vim.g.terminal_color_14 = colors.teal
  vim.g.terminal_color_15 = colors.subtext0
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return vim.notify("Set " .. option .. " to " .. vim.opt_local[option]:get(), vim.log.levels.INFO, { title = "Option" })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      vim.notify("Enabled " .. option, vim.log.levels.INFO, { title = "Option" })
    else
      vim.notify("Disabled " .. option, vim.log.levels.WARN, { title = "Option" })
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    vim.notify("Enabled diagnostics", vim.log.levels.INFO, { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    vim.notify("Disabled diagnostics", vim.log.levels.WARN, { title = "Diagnostics" })
  end
end

local nu = { number = true, relativenumber = true }
function M.toggle_number()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    ---@diagnostic disable-next-line: undefined-field
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.notify("Disabled line numbers", vim.log.levels.WARN, { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    vim.notify("Enabled line numbers", vim.log.levels.INFO, { title = "Option" })
  end
end

vim.api.nvim_create_user_command("AIStatus", function() M.ai_status() end, {})

return M
