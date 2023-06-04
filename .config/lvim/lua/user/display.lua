lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.log.level = "info"
vim.g.tokyonight_style = "night"
lvim.colorscheme = "tokyonight-night"
lvim.transparent_window = true
vim.o.conceallevel = 2
vim.o.guicursor = vim.o.guicursor .. ",a:blinkon1"
vim.o.timeoutlen = 0

-- Default folding is dubious.
-- https://github.com/preservim/vim-markdown/issues/622
vim.opt.foldlevelstart = 6
vim.g.vim_markdown_folding_level = 2
