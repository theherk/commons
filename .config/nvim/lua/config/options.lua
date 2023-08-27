vim.g.maplocalleader = ","

vim.o.conceallevel = 0 -- 2
vim.o.guicursor = vim.o.guicursor .. ",a:blinkon1"
-- vim.o.timeoutlen = 0

-- Default folding is dubious.
-- https://github.com/preservim/vim-markdown/issues/622
vim.opt.foldlevelstart = 6
vim.g.vim_markdown_folding_level = 2
