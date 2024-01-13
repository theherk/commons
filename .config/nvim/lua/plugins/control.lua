local Util = require("config.util")
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3

return {
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      local wk = require("which-key")
      wk.register({
        ["<leader>"] = {
          ["<leader>"] = { "<cmd>Telescope git_files<cr>", "files (git)" },
          ["<tab>"] = {
            name = "+tab",
            c = { "<cmd>tabclose<cr>", "close" },
            f = { "<cmd>tabfirst<cr>", "first" },
            l = { "<cmd>tablast<cr>", "last" },
            n = { "<cmd>tabnext<cr>", "next" },
            p = { "<cmd>tabprevious<cr>", "previous" },
          },
          ["-"] = "which_key_ignore",
          ["`"] = "which_key_ignore",
          ["|"] = "which_key_ignore",
          ["/"] = { "<cmd>Telescope live_grep<cr>", "grep" },
          b = {
            name = "+buffer",
            d = { function() require("mini.bufremove").delete(0, false) end, "delete" },
            D = { function() require("mini.bufremove").delete(0, true) end, "DELETE" },
            f = { "<cmd>Telescope buffers<cr>", "find" },
          },
          c = {
            name = "+code",
            f = { require("plugins.lsp.format").format({ force = true }), "fmt" },
          },
          d = {
            name = "+debug",
            d = { function() require("dapui").toggle({}) end, "dap ui" },
          },
          e = { "<cmd>Neotree toggle<cr>", "tree" },
          f = {
            name = "+file",
            f = { "<cmd>Telescope find_files<cr>", "find" },
            m = { require("harpoon.mark").add_file, "mark" },
            s = { "<cmd>w<cr>", "write" },
          },
          g = {
            name = "+git",
            b = { "<cmd>Gitsigns blame_line<cr>", "blame" },
            g = { "<cmd>Neogit<cr>", "neogit" },
            G = { Util.lazygit, "lazygit" },
          },
          J = { "<cmd>TSJToggle<cr>", "spoin" },
          K = "which_key_ignore",
          l = { "<cmd>Lazy<cr>", "lazy" },
          L = "which_key_ignore",
          n = {
            name = "+notes",
            f = { "<cmd>ObsidianQuickSwitch<cr>", "find" },
            j = {
              name = "+journal",
              m = { "<cmd>ObsidianTomorrow<cr>", "tomorrow" },
              t = { "<cmd>ObsidianToday<cr>", "today" },
              y = { "<cmd>ObsidianYesterday<cr>", "yesterday" },
            },
            n = {
              name = "+neorg",
              e = { "<cmd>Neorg export to-file <cr>", "export" },
              f = { "<cmd>Telescope neorg find_norg_files<cr>", "find" },
              h = { "<cmd>Telescope neorg search_headings<cr>", "headings" },
              i = { "<cmd>Neorg index<cr>", "index" },
              l = { "<cmd>Telescope neorg insert_link<cr>", "link" },
              L = { "<cmd>Telescope neorg insert_file_link<cr>", "file link" },
              m = { "<cmd>Neorg inject-metadata<cr>", "meta" },
              r = { "<cmd>Neorg return<cr>", "return" },
              w = { "<cmd>Telescope neorg switch_workspace<cr>", "workspace" },
              j = {
                name = "+journal",
                m = { "<cmd>Neorg journal tomorrow<cr>", "tomorrow" },
                t = { "<cmd>Neorg journal today<cr>", "today" },
                y = { "<cmd>Neorg journal yesterday<cr>", "yesterday" },
              },
            },
            w = {
              name = "+workspace",
              m = { "<cmd>ObsidianWorkspace main<cr>", "main" },
              o = { "<cmd>ObsidianWorkspace onedrive<cr>", "onedrive" },
            },
          },
          o = {
            name = "+op",
            f = { "<cmd>Fzf<cr>", "fzf" },
            p = { "<cmd>Neotree toggle<cr>", "tree" },
            s = { "<cmd>Skim<cr>", "skim" },
            t = { Util.lazyterm, "term" },
            w = { "<cmd>:set wrap!<cr>", "wrap" },
            x = { "<cmd>Xplr<cr>", "xplx" },
          },
          q = {
            name = "+quit",
            q = { "<cmd>qa<cr>", "all" },
          },
          s = {
            name = "+search",
            k = { "<cmd>Telescope keymaps<cr>", "keymaps" },
            s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "buffer" },
          },
          t = {
            name = "+test",
            t = { "<cmd>TroubleToggle<cr>", "trouble" },
          },
          u = {
            name = "+toggle",
            c = { function() Util.toggle("conceallevel", false, { 0, conceallevel }) end, "conceal" },
            d = { Util.toggle_diagnostics, "diagnostics" },
            f = { require("plugins.lsp.format").toggle, "fmt on save" },
            l = { function() Util.toggle_number() end, "line numbers" },
            s = { function() Util.toggle("spell") end, "spelling" },
            w = { function() Util.toggle("wrap") end, "wrap" },
          },
          w = {
            name = "+window",
            c = { "<c-w>c", "close" },
            s = { "<c-w>s", "horizontal" },
            v = { "<c-w>v", "vertical" },
            w = { "<c-w>p", "other" },
          },
          Z = { "<cmd>ZenMode<cr>", "zen" },
        },
        wk.setup(opts),
      })
    end,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 111
    end,
    opts = {
      key_labels = {
        ["<leader>"] = "␣",
        ["<space>"] = "␣",
        ["<cr>"] = "↵",
        ["<tab>"] = "⇥",
      },
      window = {
        border = "single",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function() require("telescope").load_extension("harpoon") end,
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
