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
          },
          c = {
            name = "+code",
            f = { require("plugins.lsp.format").format({ force = true }), "fmt" },
          },
          d = {
            name = "+debug",
            d = { function() require("dapui").toggle({}) end, "dap ui" },
          },
          f = {
            name = "+file",
            f = { "<cmd>Telescope find_files<cr>", "find" },
            s = { "<cmd>w<cr>", "write" }
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
            e = { "<cmd>Neorg export to-file <cr>", "export" },
            f = { "<cmd>Telescope neorg find_norg_files<cr>", "find" },
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
          t = { "<cmd>TroubleToggle<cr>", "trouble" },
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
      layout = {
        align = "center",
      },
      window = {
        border = "single",
      },
    },
  },
}
