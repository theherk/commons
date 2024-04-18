return {
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function() require("telescope").load_extension("nerdy") end,
    cmd = "Nerdy",
    keys = {
      { "<c-i>", "<cmd>Telescope nerdy<cr>", mode = { "i", "n" }, desc = "icons (telescope)" },
      -- { "<leader>si", function() require("telescope").extensions.nerdy.nerdy() end, desc = "icons" },
      { "<leader>si", "<cmd>Telescope nerdy<cr>", desc = "icons (telescope)" },
      { "<leader>sI", "<cmd>Nerdy<cr>", desc = "icons (select)" },
    },
  },
}
