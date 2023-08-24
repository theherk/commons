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
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    opts = { use_diagnostic_signs = true },
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
}
