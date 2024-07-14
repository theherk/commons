local function toc() vim.cmd([[ exe 'r!md-toc --indent 2 % | rg -N --color=never . | head -c -1' ]]) end
vim.keymap.set("v", "<localleader>l", "<esc><cmd>ObsidianLink<cr>", { desc = "ObsidianLink" })
vim.keymap.set("v", "<localleader>t", ":!pandoc -f markdown-simple_tables+pipe_tables -t markdown-grid_tables-multiline_tables-simple_tables+pipe_tables<cr>", { desc = "format table" })
vim.keymap.set("n", "<localleader>T", toc, { desc = "insert toc" })
vim.keymap.set("v", "<localleader>T", "d:normal <localleader>T<cr>", { desc = "insert toc" })
vim.opt_local.conceallevel = 2
