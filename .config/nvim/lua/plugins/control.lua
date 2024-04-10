return {
  {
    "echasnovski/mini.clue",
    version = false,
    lazy = false,
    opts = function()
      local miniclue = require("mini.clue")
      return {
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          { mode = "n", keys = "<leader><tab>", desc = "tab" },
          { mode = "n", keys = "<leader>b", desc = "buffer" },
          { mode = "n", keys = "<leader>c", desc = "code" },
          { mode = "n", keys = "<leader>d", desc = "debug" },
          { mode = "n", keys = "<leader>dP", desc = "python" },
          { mode = "n", keys = "<leader>f", desc = "file" },
          { mode = "n", keys = "<leader>g", desc = "git" },
          { mode = "n", keys = "<leader>gd", desc = "diffview" },
          { mode = "n", keys = "<leader>h", desc = "help" },
          { mode = "n", keys = "<leader>n", desc = "notes" },
          { mode = "n", keys = "<leader>nj", desc = "journal" },
          { mode = "n", keys = "<leader>nl", desc = "link" },
          { mode = "n", keys = "<leader>nw", desc = "workspace" },
          { mode = "n", keys = "<leader>N", desc = "neorg" },
          { mode = "n", keys = "<leader>Nj", desc = "journal" },
          { mode = "n", keys = "<leader>s", desc = "search" },
          { mode = "n", keys = "<leader>sn", desc = "noice" },
          { mode = "n", keys = "<leader>st", desc = "todo" },
          { mode = "n", keys = "<leader>u", desc = "toggle" },
          { mode = "n", keys = "<leader>w", desc = "window" },
          { mode = "n", keys = "<localleader>m", desc = "mark" },
        },
        triggers = {
          { mode = "n", keys = "<c-w>" },
          { mode = "i", keys = "<c-w>" },
          { mode = "n", keys = "<leader>" },
          { mode = "v", keys = "<leader>" },
          { mode = "n", keys = "<localleader>" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "n", keys = "g" },
          { mode = "n", keys = "z" },
        },
        window = {
          delay = 0,
          config = {
            width = "auto",
          },
        },
      }
    end,
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function() require("telescope").load_extension("harpoon") end,
    keys = {
      { "<leader>fm", function() require("harpoon.mark").add_file() end, desc = "harpoon mark" },
      { "]f", function() require("harpoon.ui").nav_next() end, desc = "harpoon next" },
      { "[f", function() require("harpoon.ui").nav_prev() end, desc = "harpoon prev" },
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
    },
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
