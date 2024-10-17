local Util = require("config.util")

-- Basics
vim.keymap.set("n", "<leader>fs", "<cmd>up<cr>", { desc = "update" })
vim.keymap.set("n", "<leader>fS", "<cmd>w<cr>", { desc = "write" })
vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "quit all" })

-- Better up/down.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Better word movement with spider.
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<cr>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<cr>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<cr>", { desc = "Spider-b" })

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
  vim.w.orig_scrolloff = vim.opt.scrolloff:get()
  vim.opt.scrolloff = 0
  scrolloff_add_autocmd()
end

local function scroll_very_bottom()
  scrolloff_disable()
  vim.cmd(":norm! zb")
end

local function scroll_very_top()
  scrolloff_disable()
  vim.cmd(":norm! zt")
end

vim.keymap.set("n", "zb", scroll_very_bottom, { desc = "redraw very bottom" })
vim.keymap.set("n", "zt", scroll_very_top, { desc = "redraw very top" })

-- Filepath yank to clipboard.
vim.keymap.set("n", "<leader>fy", ":let @+=expand('%:p')<cr>", { desc = "yank path" })

-- Replace the entire current buffer with clipboard.
vim.keymap.set("n", "<leader>br", function() vim.cmd("normal! ggVGp") end, { noremap = true, silent = true, desc = "replace contents" })

-- Navigation of windows, tabs, and buffers.
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "lower window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "upper window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "right window" })
vim.keymap.set("n", "<leader>wh", "<c-w>h", { desc = "left window" })
vim.keymap.set("n", "<leader>wj", "<c-w>j", { desc = "lower window" })
vim.keymap.set("n", "<leader>wk", "<c-w>k", { desc = "upper window" })
vim.keymap.set("n", "<leader>wl", "<c-w>l", { desc = "right window" })
vim.keymap.set("n", "<leader>wc", "<c-w>c", { desc = "close" })
vim.keymap.set("n", "<leader>ws", "<c-w>s", { desc = "split horizontal" })
vim.keymap.set("n", "<leader>wv", "<c-w>v", { desc = "split vertical" })
vim.keymap.set("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "close tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "next tab" })
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "previous tab" })

-- Resize window using <ctrl> arrow keys.
vim.keymap.set("n", "<c-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<c-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<c-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<c-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Quickfix
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "next quickfix" })

-- Utility toggles.
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set("n", "<leader>uc", function() Util.toggle("conceallevel", false, { 0, conceallevel }) end, { desc = "conceal" })
vim.keymap.set("n", "<leader>ud", function() Util.toggle_diagnostics() end, { desc = "diagnostics" })
vim.keymap.set("n", "<leader>ul", function() Util.toggle_number() end, { desc = "line numbers" })
vim.keymap.set("n", "<leader>us", function() Util.toggle("spell") end, { desc = "spelling" })
vim.keymap.set("n", "<leader>uS", function() Util.toggle("scrolloff", false, { 0 }) end, { desc = "scrolloff" })
vim.keymap.set("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "wrap" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })

-- buffers
if Util.has("bufferline.nvim") then
  vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "prev buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "next buffer" })
  vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "next buffer" })
elseif Util.has("nvim-cokeline") then
  vim.keymap.set("n", "<S-h>", "<plug>(cokeline-focus-prev)", { desc = "prev buffer" })
  vim.keymap.set("n", "<S-l>", "<plug>(cokeline-focus-next)", { desc = "next buffer" })
  vim.keymap.set("n", "[b", "<plug>(cokeline-focus-prev)", { desc = "prev buffer" })
  vim.keymap.set("n", "]b", "<plug>(cokeline-focus-next)", { desc = "next buffer" })
  vim.keymap.set("n", "<leader>bp", "<plug>(cokeline-pick-focus)", { desc = "pick focus" })
  vim.keymap.set("n", "<leader>bc", "<plug>(cokeline-pick-close)", { desc = "pick close" })
else
  vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "prev buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })
  vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "next buffer" })
end
vim.keymap.set("n", "<leader>bO", "<cmd>%bd|e#|bd#<cr>", { desc = "others (native)" })

-- Clear search with <esc>.
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "clear hlsearch" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "line diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "next diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "prev diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "next error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "prev error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "next warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "prev warning" })

-- Save the weird way.
vim.keymap.set({ "i", "x", "n", "s" }, "<c-s>", "<cmd>up<cr><esc>", { desc = "save (update) file" })
vim.keymap.set({ "i", "x", "n", "s" }, "<cs-S>", "<cmd>w<cr><esc>", { desc = "save (write) file" })

-- Better indenting.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- EasyAlign
vim.keymap.set("v", "ga", "<Plug>(EasyAlign)")

-- Open Lazy interface.
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "lazy" })
