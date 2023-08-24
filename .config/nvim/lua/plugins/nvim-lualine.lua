local custom = require("lualine.themes.tokyonight")
custom.normal.c.bg = "none"

return {
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
