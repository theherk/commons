local M = {}

local function scrolloff_should_reenable()
  if vim.w.orig_scrolloff == nil then return false end -- Nothing to do.
  if vim.fn.winheight(0) <= vim.w.orig_scrolloff then return true end -- Too small for override.
  return vim.w.orig_scrolloff < vim.fn.winline() and vim.fn.winline() < vim.fn.winheight(0) - vim.w.orig_scrolloff
end

local function scrolloff_add_autocmd()
  vim.api.nvim_create_augroup("h4s_scrolloff_enhanced", { clear = true })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "h4s_scrolloff_enhanced",
    callback = function()
      if scrolloff_should_reenable() then
        vim.opt.scrolloff = vim.w.orig_scrolloff
        vim.w.orig_scrolloff = nil
        return true -- Remove the autocmd.
      end
    end,
  })
end

local function scrolloff_disable()
  vim.w.orig_scrolloff = vim.o.scrolloff
  vim.opt.scrolloff = 0
  scrolloff_add_autocmd()
end

function M.very_bottom()
  scrolloff_disable()
  vim.cmd(":norm! zb")
end

function M.very_top()
  scrolloff_disable()
  vim.cmd(":norm! zt")
end

return M
