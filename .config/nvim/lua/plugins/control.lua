return {
  {
    "echasnovski/mini.clue",
    version = false,
    lazy = false,
    opts = {
      triggers = { { mode = "n", keys = "<Leader>" } },
      window = { delay = 0 },
    },
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function() require("telescope").load_extension("harpoon") end,
    keys = {
      { "<leader>fm", function() require("harpoon.mark").add_file() end, desc = "harpoon mark" },
      { "]f", function() require("harpoon.ui").nav_next() end, mode = { "i", "n" }, desc = "harpoon next" },
      { "[f", function() require("harpoon.ui").nav_prev() end, mode = { "i", "n" }, desc = "harpoon prev" },
      { "<c-,>", function() require("harpoon.ui").toggle_quick_menu() end, mode = { "i", "n" }, desc = "harpoon marks" },
      { "<c-1>", function() require("harpoon.ui").nav_file(1) end, mode = { "i", "n" }, desc = "harpoon file 1" },
      { "<c-2>", function() require("harpoon.ui").nav_file(2) end, mode = { "i", "n" }, desc = "harpoon file 2" },
      { "<c-3>", function() require("harpoon.ui").nav_file(3) end, mode = { "i", "n" }, desc = "harpoon file 3" },
      { "<c-4>", function() require("harpoon.ui").nav_file(4) end, mode = { "i", "n" }, desc = "harpoon file 4" },
      { "<c-5>", function() require("harpoon.ui").nav_file(5) end, mode = { "i", "n" }, desc = "harpoon file 5" },
      { "<c-6>", function() require("harpoon.ui").nav_file(6) end, mode = { "i", "n" }, desc = "harpoon file 6" },
      { "<c-7>", function() require("harpoon.ui").nav_file(7) end, mode = { "i", "n" }, desc = "harpoon file 7" },
      { "<c-8>", function() require("harpoon.ui").nav_file(8) end, mode = { "i", "n" }, desc = "harpoon file 8" },
      { "<c-9>", function() require("harpoon.ui").nav_file(9) end, mode = { "i", "n" }, desc = "harpoon file 9" },
    }
  },
  {
    "voldikss/vim-browser-search",
    config = function()
      -- Better to update the defaults since they aren't removed otherwise.
      -- vim.g.browser_search_engines = {}
      vim.g.browser_search_builtin_engines = {
        duckduckgo = "https://duckduckgo.com/?q=%s",
        github = "https://github.com/search?q=%s",
        gitlab = "https://gitlab.com/search?search=%s",
        google = "https://google.com/search?q=%s",
        mdn = "https://developer.mozilla.org/en-US/search?q=%s",
        scholar = "https://scholar.google.com/scholar?q=%s",
        stackoverflow = "https://stackoverflow.com/search?q=%s",
        translate = "https://translate.google.com/?sl=auto&tl=en&text=%s",
        wikipedia = "https://en.wikipedia.org/wiki/%s",
        youtube = "https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch",
      }
      vim.g.browser_search_default_engine = "duckduckgo"
    end,
    event = "VeryLazy",
    keys = {
      -- Command BrowserSearch always searches one less than index given.
      { "<leader>sb", ":BrowserSearch<space>", desc = "browser" },
      { "<c-k>", "<Plug>SearchNormal", desc = "browser search" },
      { "<c-k>", "<Plug>SearchVisual", desc = "browser search", mode = "v" },
    },
  },
}
