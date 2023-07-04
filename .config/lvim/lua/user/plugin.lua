vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

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
    config = true,
  },
  {
    "folke/tokyonight.nvim"
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        plugins = {
          wezterm = {
            enabled = true,
            font = "+2",
          },
        },
        window = {
          width = 0.77,
        }
      }
    end
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
    "junegunn/vim-easy-align",
  },
  {
    "kevinhwang91/nvim-bqf",
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                main = "~/org/neorg",
                icloud = "~/Library/Mobile Documents/com~apple~CloudDocs/neorg",
                onedrive = os.getenv("NEORG_ONEDRIVE") or "~/Library/CloudStorage/OneDrive/neorg"
              },
              default_workspace = os.getenv("NEORG_DEFAULT_WORKSPACE") or "main"
            },
          },
          ["core.export"] = {
            config = {
              export_dir = "~/org/export/<language>"
            }
          },
          ["core.export.markdown"] = {},
          ["core.integrations.telescope"] = {},
          ["core.journal"] = {
            config = {
              workspace = os.getenv("NEORG_DEFAULT_WORKSPACE") or "main"
            }
          },
          ["core.keybinds"] = {
            config = {
              hook = function(keybinds)
                keybinds.remap_event("norg", "i", "<C-CR>", "core.itero.next-iteration")
                keybinds.remap_event("norg", "n", "<C-CR>", "core.itero.next-iteration")
              end,
            }
          },
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode"
            }
          },
          ["core.summary"] = {},
        },
      }
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
    },
  },
  {
    "preservim/vim-markdown",
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
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
    config = true,
  },
}
