local Util = require("config.util")

vim.g.neovide_detach_on_quit = "always_detach"
vim.g.neovide_transparency = 0.91247
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
vim.g.neovide_cursor_vfx_particle_curl = 0.66
vim.g.neovide_cursor_vfx_particle_density = 23.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.33
vim.g.neovide_cursor_vfx_particle_phase = 11.1

vim.keymap.set("n", "<c-p>", function()
  local cmd = [[zoxide query -l | rg --color=never -FxNf ~/.projects | sed "s:$HOME:~:" ]]
  local dirs = vim.fn.systemlist(cmd)

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Projects",
      finder = finders.new_table({
        results = dirs,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          local dir = vim.fn.expand(selection[1])
          vim.fn.system({ "open", "-a", "NeovideProject", dir })
        end)
        return true
      end,
    })
    :find()
end)
