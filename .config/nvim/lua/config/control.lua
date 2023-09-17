local Util = require("config.util")

-- Better up/down.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys.
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Go to right window" })

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

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Save the weird way.
vim.keymap.set({ "i", "x", "n", "s" }, "<c-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better indenting.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- EasyAlign
vim.keymap.set("v", "ga", "<Plug>(EasyAlign)")

-- Harpoon
vim.keymap.set({ "i", "n" }, "]f", require("harpoon.ui").nav_next, { desc = "harpoon next file" })
vim.keymap.set({ "i", "n" }, "[f", require("harpoon.ui").nav_prev, { desc = "harpoon prev file" })
vim.keymap.set({ "i", "n" }, "<c-h>", require("harpoon.ui").toggle_quick_menu, { desc = "harpoon marks" })
vim.keymap.set({ "i", "n" }, "<c-1>", function() require("harpoon.ui").nav_file(1) end, { desc = "harpoon file 1" })
vim.keymap.set({ "i", "n" }, "<c-2>", function() require("harpoon.ui").nav_file(2) end, { desc = "harpoon file 2" })
vim.keymap.set({ "i", "n" }, "<c-3>", function() require("harpoon.ui").nav_file(3) end, { desc = "harpoon file 3" })
vim.keymap.set({ "i", "n" }, "<c-4>", function() require("harpoon.ui").nav_file(4) end, { desc = "harpoon file 4" })
vim.keymap.set({ "i", "n" }, "<c-5>", function() require("harpoon.ui").nav_file(5) end, { desc = "harpoon file 5" })
vim.keymap.set({ "i", "n" }, "<c-6>", function() require("harpoon.ui").nav_file(6) end, { desc = "harpoon file 6" })
vim.keymap.set({ "i", "n" }, "<c-7>", function() require("harpoon.ui").nav_file(7) end, { desc = "harpoon file 7" })
vim.keymap.set({ "i", "n" }, "<c-8>", function() require("harpoon.ui").nav_file(8) end, { desc = "harpoon file 8" })
vim.keymap.set({ "i", "n" }, "<c-9>", function() require("harpoon.ui").nav_file(9) end, { desc = "harpoon file 9" })

-- Trouble jumps.
if not Util.has("trouble.nvim") then
  vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
  vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- Terminal Mappings
vim.keymap.set("n", "<c-\\>", Util.lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<c-/>", Util.lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<c-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<c-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<c-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<c-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
vim.keymap.set("t", "<c-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
