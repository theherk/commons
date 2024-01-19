vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.guicursor = vim.o.guicursor .. ",a:blinkon1"

vim.opt.autowrite = true
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 1
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.laststatus = 0
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.scrolloff = 4
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append({ W = true, I = true, c = true })
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.wrap = false

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Default folding is dubious.
-- https://github.com/preservim/vim-markdown/issues/622
vim.opt.foldlevelstart = 6
vim.g.vim_markdown_folding_level = 2

-- Neovide
vim.o.guifont = "VictorMono NF:h18"
local alpha = function() return string.format("%x", math.floor(255 * vim.g.transparency)) end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.0
vim.g.transparency = 0.94247
vim.g.neovide_background_color = "#16161e" .. alpha()

if vim.g.neovide then vim.cmd("cd ~/Downloads/") end
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_cursor_vfx_particle_density = 23.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 0.8
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_curl = 0.66
vim.g.neovide_cursor_vfx_particle_density = 23.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.33
vim.g.neovide_cursor_vfx_particle_phase = 11.1
