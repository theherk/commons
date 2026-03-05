local M = {}

M.opts = nil

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
  require("conform").format({ bufnr = buf, lsp_fallback = true })
end

return M
