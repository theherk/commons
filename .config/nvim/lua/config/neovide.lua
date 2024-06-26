vim.g.neovide_transparency = 0.85247
vim.g.neovide_theme = "auto"

-- Background is none and comes from the terminal.
-- When running Neovide, it must be set.
-- These are bespoke to specific colorschemes.
if vim.g.colors_name == "tokyonight" then vim.api.nvim_set_hl(0, "Normal", { bg = require("tokyonight.colors").setup().bg }) end
if vim.g.colors_name == "catppuccin-latte" then vim.api.nvim_set_hl(0, "Normal", { bg = require("catppuccin.palettes").get_palette("latte").base }) end

-- Cursor

-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_cursor_vfx_particle_density = 23.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 0.8

vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_curl = 0.66
vim.g.neovide_cursor_vfx_particle_density = 23.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.33
vim.g.neovide_cursor_vfx_particle_phase = 11.1
