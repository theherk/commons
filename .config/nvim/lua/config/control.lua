local Util = require("config.util")

-- Better up/down.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope git_files<cr>", { desc = "files (git)"})
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", { desc = "find files"})

-- Navigation of windows, tabs, and buffers.
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "toggle tree"})
vim.keymap.set("n", "<c-p>", "<cmd>Neotree toggle<cr>", { desc = "toggle tree"})
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
