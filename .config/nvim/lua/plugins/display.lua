local custom = require("lualine.themes.tokyonight")
custom.normal.c.bg = "none"
local icons = require("lazyvim.config").icons

return {
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = true,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        plugins = {
          wezterm = {
            enabled = true,
            font = "+2",
          },
        },
        window = {
          width = 0.77,
        },
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  {
    "junegunn/vim-easy-align",
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = custom
      opts.options.section_separators = { left = "", right = "" }
      opts.sections.lualine_a = {
        {
          "mode",
          separator = { left = "" },
          right_padding = 2,
        },
      }
      opts.sections.lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 0, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        {
          function()
            return require("nvim-navic").get_location()
          end,
          cond = function()
            return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
          end,
          padding = { left = 1, right = 0 },
        },
      }
      opts.sections.lualine_z = {
        {
          function()
            return " " .. os.date("%R")
          end,
          separator = { right = "" },
          left_padding = 2,
        },
      }
    end,
  },
}
