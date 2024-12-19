return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shade_terminals = false,
    },
    keys = {
      { "<c-`>", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "terminal (horizontal)", mode = { "i", "x", "n", "s", "t" } },
      { "<d-j>", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "terminal (horizontal)", mode = { "i", "x", "n", "s", "t" } },
      { "<ds-j>", "<cmd>ToggleTerm direction=tab<cr>", desc = "terminal (tab)", mode = { "i", "x", "n", "s", "t" } },
    },
  },
  { "glacambre/firenvim", build = ":call firenvim#install(0)" },
}
