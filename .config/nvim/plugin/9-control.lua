local Scroll = require("module.scroll")
local Util = require("module.util")

-- Basics
vim.keymap.set("n", "<leader>fs", "<cmd>up<cr>", { desc = "update" })
vim.keymap.set("n", "<leader>fS", "<cmd>w<cr>", { desc = "write" })
vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "quit all" })

-- Better up/down.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Better scrolloff.
vim.keymap.set("n", "zb", Scroll.very_bottom, { desc = "redraw very bottom" })
vim.keymap.set("n", "zt", Scroll.very_top, { desc = "redraw very top" })

-- Filepath yank to clipboard.
vim.keymap.set("n", "<leader>fy", ":let @+=expand('%:p')<cr>", { desc = "yank path" })

-- Replace the entire current buffer with clipboard.
vim.keymap.set("n", "<leader>br", function() vim.cmd("normal! ggVGp") end, { noremap = true, silent = true, desc = "replace contents" })

-- Navigation of tabs.
vim.keymap.set("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "close tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "next tab" })
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "previous tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "next tab" })

-- Resize window using <ctrl> arrow keys.
vim.keymap.set("n", "<c-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<c-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<c-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<c-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Quickfix
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "next quickfix" })

-- Toggles.
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set("n", "<leader>tc", function() Util.toggle("conceallevel", false, { 0, conceallevel }) end, { desc = "conceal" })
vim.keymap.set("n", "<leader>td", function() Util.toggle_diagnostics() end, { desc = "diagnostics" })
vim.keymap.set("n", "<leader>tl", function() Util.toggle_number() end, { desc = "line numbers" })
vim.keymap.set("n", "<leader>ts", function() Util.toggle("spell") end, { desc = "spelling" })
vim.keymap.set("n", "<leader>tS", function() Util.toggle("scrolloff", false, { 0 }) end, { desc = "scrolloff" })
vim.keymap.set("n", "<leader>tw", function() Util.toggle("wrap") end, { desc = "wrap" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })

-- buffers
vim.keymap.set("i", "<d-[>", "<esc><plug>(cokeline-focus-prev)", { desc = "prev buffer" })
vim.keymap.set("i", "<d-]>", "<esc><plug>(cokeline-focus-next)", { desc = "next buffer" })
vim.keymap.set({ "n", "t" }, "<d-[>", "<plug>(cokeline-focus-prev)", { desc = "prev buffer" })
vim.keymap.set({ "n", "t" }, "<d-]>", "<plug>(cokeline-focus-next)", { desc = "next buffer" })
vim.keymap.set("n", "<s-h>", "<plug>(cokeline-focus-prev)", { desc = "prev buffer" })
vim.keymap.set("n", "<s-l>", "<plug>(cokeline-focus-next)", { desc = "next buffer" })
vim.keymap.set("n", "[b", "<plug>(cokeline-focus-prev)", { desc = "prev buffer" })
vim.keymap.set("n", "]b", "<plug>(cokeline-focus-next)", { desc = "next buffer" })
vim.keymap.set("n", "<leader>bp", "<plug>(cokeline-pick-focus)", { desc = "pick focus" })
vim.keymap.set("n", "<leader>bc", "<plug>(cokeline-pick-close)", { desc = "pick close" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "others (native)" })

-- Clear search with <esc>.
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "clear hlsearch" })

-- Diagnostic
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
vim.keymap.set({ "i", "x", "n", "s" }, "<d-s>", "<cmd>w<cr><esc>", { desc = "save (write) file" })

-- Better indenting.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Paste
vim.keymap.set("n", "<d-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("i", "<d-v>", "<c-r>+", { noremap = true, silent = true })
vim.keymap.set("c", "<d-v>", "<c-r>+", { noremap = true })
vim.keymap.set("t", "<d-v>", '<C-\\><C-N>"+pi', { noremap = true })

-- Treewalker
vim.keymap.set("n", "<C-k>", "<cmd>Treewalker Up<cr>", { silent = true })
vim.keymap.set("n", "<C-j>", "<cmd>Treewalker Down<cr>", { silent = true })
vim.keymap.set("n", "<C-l>", "<cmd>Treewalker Right<cr>", { silent = true })
vim.keymap.set("n", "<C-h>", "<cmd>Treewalker Left<cr>", { silent = true })
vim.keymap.set("n", "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true })
vim.keymap.set("n", "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true })
vim.keymap.set("n", "<C-S-l>", "<cmd>Treewalker SwapRight<CR>", { silent = true })
vim.keymap.set("n", "<C-S-h>", "<cmd>Treewalker SwapLeft<CR>", { silent = true })

-- Adjust fontsize in gui contexts.
vim.keymap.set({ "n", "i" }, "<c-+>", function() Util.increment_font(1) end, { desc = "increase font size" })
vim.keymap.set({ "n", "i" }, "<c-=>", function() Util.increment_font(-1) end, { desc = "decrease font size" })
