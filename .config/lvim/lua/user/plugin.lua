require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = { "~/org/*" },
})

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
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  {
    "nvim-orgmode/orgmode",
    config = function()
      require('orgmode').setup({})
    end
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
