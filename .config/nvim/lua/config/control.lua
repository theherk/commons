local Util = require("config.util")

-- Basics
vim.keymap.set("n", "<leader>fs", "<cmd>w<cr>", { desc = "write" })
vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "quit all" })

-- Better up/down.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Navigation of windows, tabs, and buffers.
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "lower window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "upper window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "right window" })
vim.keymap.set("n", "<tab>c", "<cmd>tabclose<cr>", { desc = "close tab" })
vim.keymap.set("n", "<tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
vim.keymap.set("n", "<tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
vim.keymap.set("n", "<tab>n", "<cmd>tabnext<cr>", { desc = "next tab" })
vim.keymap.set("n", "<tab>p", "<cmd>tabprevious<cr>", { desc = "previous tab" })

-- Resize window using <ctrl> arrow keys.
vim.keymap.set("n", "<c-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<c-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<c-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<c-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- buffers
if Util.has("bufferline.nvim") then
  vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

-- Clear search with <esc>.
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Save the weird way.
vim.keymap.set({ "i", "x", "n", "s" }, "<c-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better indenting.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- EasyAlign
vim.keymap.set("v", "ga", "<Plug>(EasyAlign)")

-- Format markdown tables.
vim.keymap.set("v", "<leader>ct", ":!pandoc -t markdown-simple_tables<cr>", { desc = "fmt table" })
