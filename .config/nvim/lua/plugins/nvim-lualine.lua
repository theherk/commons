local custom = require("lualine.themes.tokyonight")
custom.normal.c.bg = "none"

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = custom
    end,
  },
}
