return {
  {
    "Asheq/close-buffers.vim",
    keys = {
      { "<leader>bo", "<cmd>Bdelete other<cr>", desc = "close other buffers" },
    },
  },
  {
    "benfowler/telescope-luasnip.nvim",
    keys = {
      { "<leader>sS", "<cmd>Telescope luasnip<cr>", desc = "telescope snippets" },
    },
  },
  {
    "echasnovski/mini.bufremove",
    config = true,
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "delete buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "delete buffer (force)" },
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function() return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring end,
      },
    },
  },
  {
    "echasnovski/mini.files",
    keys = {
      { "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "explore" },
      { "<leader>fe", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "explore" },
    },
    opts = {
      mappings = {
        go_in_plus = "<cr>",
      },
      windows = {
        width_focus = 28,
        width_nofocus = 16,
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "delete surrounding" },
        { opts.mappings.find, desc = "find right surrounding" },
        { opts.mappings.find_left, desc = "find left surrounding" },
        { opts.mappings.highlight, desc = "highlight surrounding" },
        { opts.mappings.replace, desc = "replace surrounding" },
        { opts.mappings.update_n_lines, desc = "update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "prev todo" },
      { "<leader>stf", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "todo/fix/fixme" },
      { "<leader>stq", "<cmd>TodoQuickFix<cr>", desc = "todo quickfix" },
      { "<leader>stt", "<cmd>TodoTelescope<cr>", desc = "todo telescope" },
      { "<leader>stT", "<cmd>TodoTrouble<cr>", desc = "todo trouble" },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>ut", "<cmd>TroubleToggle<cr>", desc = "toggle trouble" },
    },
  },
  {
    "ggandor/flit.nvim",
    keys = function()
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "Exafunction/codeium.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<c-b>"] = cmp.mapping.scroll_docs(-4),
          ["<c-f>"] = cmp.mapping.scroll_docs(4),
          ["<c-space>"] = cmp.mapping.complete(),
          ["<c-e>"] = cmp.mapping.abort(),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
          ["<s-cr>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        sources = cmp.config.sources({
          { name = "codeium" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("config.icons").icons.kinds
            if icons[item.kind] then item.kind = icons[item.kind] .. item.kind end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "kevinhwang91/nvim-bqf" },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "LunarVim/bigfile.nvim",
    -- Dasable somethings if a huge file is opened...
    -- but be sane and just open with bat or nvim --clean.
    event = { "FileReadPre", "BufReadPre" },
    lazy = false,
    opts = {
      filesize = 2,
    },
  },
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "echasnovski/mini.icons",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {},
          never_show = {},
        },
        follow_current_file = { enabled = true },
      },
    },
    keys = {
      { "<c-p>", "<cmd>Neotree toggle<cr>", desc = "toggle neotree" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
      pickers = {
        live_grep = { additional_args = function(_) return { "--hidden", "--glob=!.git/" } end },
        keymaps = { theme = "dropdown" },
        spell_suggest = { theme = "cursor" },
      },
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope git_files<cr>", desc = "git files" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "grep" },
      { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "find buffers" },
      { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "find buffers" },
      { "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "document symbols" },
      { "<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "workspace symbols" },
      { "<leader>ff", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "find files" },
      { "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "telescope help" },
      { "<leader>hs", "<cmd>Telescope spell_suggest<cr>", desc = "spell" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "keymaps" },
      { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "buffer / swiper" },
      { "z=", "<cmd>Telescope spell_suggest<cr>", desc = "spell" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
    },
    cmd = { "TSUpdateSync" },
    opts = {
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "comment",
        "gleam",
        "hcl",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "norg",
        "org",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then return false end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>J", "<cmd>TSJToggle<cr>", desc = "spoin" },
    },
    opts = {
      use_default_keymaps = false,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "flake8",
        "prettierd",
        "shfmt",
        "stylua",
      },
    },
  },
}
