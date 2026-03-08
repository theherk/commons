-- Workaround for Neovim 0.11.x bug: nil handle in vim.lsp.completion InsertCharPre
-- The on_detach callback nils buf_handles[bufnr] but the InsertCharPre autocmd
-- persists, causing crash at completion.lua:573. Wrap enable to add nil guard.
-- Safe to remove once upgraded past the fix (neovim/neovim#32kind).

local completion = vim.lsp.completion
if not completion or not completion.enable then return end

local orig_enable = completion.enable

---@diagnostic disable-next-line: duplicate-set-field
completion.enable = function(enable, client_id, bufnr, opts)
  orig_enable(enable, client_id, bufnr, opts)
  if not enable then return end

  bufnr = vim._resolve_bufnr(bufnr)
  local group_name = string.format("nvim.lsp.completion_%d", bufnr)
  local ok, autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group_name,
    buffer = bufnr,
    event = "InsertCharPre",
  })
  if not ok then return end

  for _, au in ipairs(autocmds) do
    local orig_cb = au.callback
    if orig_cb then
      vim.api.nvim_del_autocmd(au.id)
      vim.api.nvim_create_autocmd("InsertCharPre", {
        group = group_name,
        buffer = bufnr,
        callback = function()
          local success, err = pcall(orig_cb)
          if not success and err and err:find("nil value") then return end
          if not success then error(err) end
        end,
      })
    end
  end
end
