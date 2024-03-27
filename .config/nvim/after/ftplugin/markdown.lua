local function toc() vim.cmd([[ exe 'r!md-toc --indent 2 % | rg -N --color=never . | head -c -1' ]]) end
vim.keymap.set("v", "<localleader>l", "<esc><cmd>ObsidianLink<cr>", { desc = "ObsidianLink" })
vim.keymap.set("v", "<localleader>t", ":!pandoc -t markdown-simple_tables<cr>", { desc = "fmt table" })
vim.keymap.set("n", "<localleader>T", toc, { desc = "insert toc" })
vim.keymap.set("v", "<localleader>T", "d:normal <localleader>T<cr>", {})
vim.opt_local.conceallevel = 2
