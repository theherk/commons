lvim.plugins = {
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "folke/tokyonight.nvim"
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "preservim/vim-markdown",
  },
  {
    "Wansmer/treesj",
    config = function()
      require('treesj').setup({})
    end,
  },
}
