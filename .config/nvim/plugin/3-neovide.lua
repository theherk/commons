local MiniDeps = require("mini.deps")
local now = MiniDeps.now
local Util = require("module.util")

if vim.g.neovide then
  now(function()
    vim.g.neovide_detach_on_quit = "always_detach"
    vim.g.neovide_floating_corner_radius = 0.333
    vim.g.neovide_opacity = 1
    vim.g.neovide_theme = "auto"

    -- Background is none and comes from the terminal.
    -- When running Neovide, it must be set.
    -- These are bespoke to specific colorschemes.
    -- vim.notify(vim.g.colors_name, "info")
    if vim.g.colors_name == "catppuccin-frappe" then
      local colors = require("catppuccin.palettes").get_palette("frappe")
      vim.api.nvim_set_hl(0, "Normal", { bg = colors.base })
      Util.set_cursor_colors(colors)
      Util.set_term_colors(colors)
    end
    if vim.g.colors_name == "catppuccin-latte" then
      local colors = require("catppuccin.palettes").get_palette("latte")
      vim.api.nvim_set_hl(0, "Normal", { bg = colors.base })
      Util.set_cursor_colors(colors)
      Util.set_term_colors(colors)
    end
    if vim.g.colors_name == "tokyonight-night" then
      local colors = require("tokyonight.colors").setup()
      vim.api.nvim_set_hl(0, "Normal", { bg = colors.bg })
      Util.set_cursor_colors(colors)
      Util.set_term_colors(colors)
    end

    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true
    vim.g.neovide_cursor_smooth_blink = true
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_vfx_particle_curl = 0.77
    vim.g.neovide_cursor_vfx_particle_density = 3.25
    vim.g.neovide_cursor_vfx_particle_lifetime = 1.33
    vim.g.neovide_cursor_vfx_particle_phase = 12.1
  end)
end
