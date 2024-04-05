-- Neovide
local alpha = function() return string.format("%x", math.floor(255 * vim.g.transparency)) end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
-- vim.g.neovide_transparency = 0.0
-- vim.g.transparency = 0.94247
-- vim.g.neovide_background_color = "#16161e" .. alpha()

-- Cursor

-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_cursor_vfx_particle_density = 23.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 0.8

vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_curl = 0.66
vim.g.neovide_cursor_vfx_particle_density = 23.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.33
vim.g.neovide_cursor_vfx_particle_phase = 11.1
