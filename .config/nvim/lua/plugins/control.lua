return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
      local mi = require("mini.icons")
      return {
        preset = "helix",
        show_help = false,
        spec = {
          { "<leader>f", group = "file", icon = mi.get("default", "file") },
          { "<leader><tab>", group = "tab" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dP", group = "python" },
          { "<leader>f", group = "file" },
          { mode = { "n", "v" }, "<leader>g", group = "git" },
          { "<leader>gd", group = "diffview" },
          { mode = { "n", "v" }, "<leader>gl", group = "link" },
          { "<leader>h", group = "help", icon = { color = "azure", cat = "filetype", name = "help" } },
          { "<leader>n", group = "notes", icon = { color = "purple", cat = "filetype", name = "markdown" } },
          { "<leader>nj", group = "journal" },
          { mode = { "n", "v" }, "<leader>nl", group = "link" },
          { "<leader>nw", group = "workspace" },
          { "<leader>N", group = "neorg", icon = mi.get("filetype", "norg") },
          { "<leader>Nj", group = "journal" },
          { "<leader>s", group = "search" },
          { "<leader>sn", group = "noice" },
          { "<leader>st", group = "todo" },
          { "<leader>u", group = "toggle" },
          { "<leader>w", group = "window" },
          { "<localleader>m", group = "mark" },
        },
        win = {
          height = { max = 44 },
          padding = { 1, 1 },
          title_pos = "center",
        },
        layout = {
          spacing = 4,
          align = "center",
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
