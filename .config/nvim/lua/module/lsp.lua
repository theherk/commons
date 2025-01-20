local M = {}

M.opts = nil

-- Format helpers
function M.enabled() return M.opts.autoformat end

function M.toggle()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.opts.autoformat = true
  else
    M.opts.autoformat = not M.opts.autoformat
  end
  if M.opts.autoformat then
    vim.notify("Enabled format on save", vim.log.levels.INFO, { title = "Format" })
  else
    vim.notify("Disabled format on save", vim.log.levels.WARN, { title = "Format" })
  end
end

---@param opts? {force?:boolean}
function M.format(opts)
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false and not (opts and opts.force) then return end

  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client) return client.id end, formatters.active)

  if #client_ids == 0 then return end

  if M.opts.format_notify then M.notify(formatters) end

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client) return vim.tbl_contains(client_ids, client.id) end,
  })
end

-- Gets all lsp clients that support formatting
function M.get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  -- check if we have any null-ls formatters for the current filetype
  local null_ls = package.loaded["null-ls"] and require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") or {}

  local ret = {
    active = {},
    available = {},
    null_ls = null_ls,
  }

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

function M.supports_format(client)
  if client.config and client.config.capabilities and client.config.capabilities.documentFormattingProvider == false then return false end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

function M.notify(formatters)
  local lines = { "# Active:" }

  for _, client in ipairs(formatters.active) do
    local line = "- **" .. client.name .. "**"
    if client.name == "null-ls" then line = line .. " (" .. table.concat(vim.tbl_map(function(f) return "`" .. f.name .. "`" end, formatters.null_ls), ", ") .. ")" end
    table.insert(lines, line)
  end

  if #formatters.available > 0 then
    table.insert(lines, "")
    table.insert(lines, "# Disabled:")
    for _, client in ipairs(formatters.available) do
      table.insert(lines, "- **" .. client.name .. "**")
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = "Formatting",
    on_open = function(win)
      vim.api.nvim_win_set_option(win, "conceallevel", 3)
      vim.api.nvim_win_set_option(win, "spell", false)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "markdown")
    end,
  })
end

return M
