vim.g.mapleader = " "
vim.g.maplocalleader = ","

local blink = "blinkwait777-blinkon1111-blinkoff666-Cursor"
local normal_cursor = "c-n-v-ve:block-" .. blink
local insert_cursor = "i-ci:ver25-" .. blink
local replace_cursor = "r-cr:hor20-" .. blink
local operator_cursor = "o:hor50-" .. blink
local showmatch_cursor = "sm:block-" .. blink

-- Follow: https://github.com/neovim/neovim/pull/31562
vim.o.guicursor = table.concat({
  normal_cursor,
  insert_cursor,
  replace_cursor,
  operator_cursor,
  showmatch_cursor,
}, ",")

vim.o.guifont = "VictorMono NF:h18"

vim.opt.autowrite = true
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 3
vim.opt.cursorline = false
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
vim.opt.spelllang = { "en", "nb" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.termsync = false
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.wrap = false

-- Default folding is dubious.
-- https://github.com/preservim/vim-markdown/issues/622
vim.opt.foldlevelstart = 6
vim.g.vim_markdown_folding_level = 2
