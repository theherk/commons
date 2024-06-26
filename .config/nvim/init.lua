require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then vim.fn.system({
  "git",
  "clone",
  "--filter=blob:none",
  "https://github.com/folke/lazy.nvim.git",
  "--branch=stable",
  lazypath,
}) end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  defaults = { version = false },
  spec = {
    { import = "plugins" },
    { import = "plugins.lang.docker" },
    { import = "plugins.lang.go" },
    { import = "plugins.lang.java" },
    { import = "plugins.lang.json" },
    { import = "plugins.lang.python" },
    { import = "plugins.lang.rust" },
    { import = "plugins.lang.terraform" },
    { import = "plugins.lang.typescript" },
    { import = "plugins.lang.yaml" },
  },
  install = { colorscheme = { "tokyonight" } },
})
require("config.autocmds")
require("config.control")
vim.cmd.colorscheme("tokyonight")
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })

if vim.g.neovide then require("config.neovide") end
