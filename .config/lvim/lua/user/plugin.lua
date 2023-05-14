vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = { "~/org/*" },
})

lvim.plugins = {
  {
    "Exafunction/codeium.vim",
    config = function()
      vim.g.codeium_enabled = false
    end,
  },
  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },
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
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
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
    "neovim/nvim-lspconfig",
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
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require('crates').setup()
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    -- Thread: https://github.com/LunarVim/LunarVim/discussions/3201
    config = function()
      local status_ok, rust_tools = pcall(require, "rust-tools")
      if not status_ok then
        return
      end
      local opts = {
        tools = {
          executor = require("rust-tools/executors").quickfix, -- can be quickfix or termopen
          reload_workspace_from_cargo_toml = true,
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<-",
            other_hints_prefix = "=>",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          on_attach = require("lvim.lsp").common_on_attach,
          on_init = require("lvim.lsp").common_on_init,
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
                extraArgs = { "--all", "--", "-W", "clippy::all" },
              }
            }
          },
        },
      }
      --local extension_path = vim.fn.expand "~/" .. ".vscode/extensions/vadimcn.vscode-lldb-1.7.3/"

      --local codelldb_path = extension_path .. "adapter/codelldb"
      --local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

      --opts.dap = {
      --        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
      --}
      rust_tools.setup(opts)
    end,
    ft = { "rust", "rs" },
  },
  {
    "Wansmer/treesj",
    config = function()
      require('treesj').setup({})
    end,
  },
}
