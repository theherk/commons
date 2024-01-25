require("config.options")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  defaults = { version=false },
  spec = { { import = "plugins" } },
  install = { colorscheme = { "tokyonight" } },
})
require("config.control")
vim.cmd.colorscheme("tokyonight")
