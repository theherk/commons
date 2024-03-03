return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "delete non-pinned buffers" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("config.icons").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "") .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        show_buffer_close_icons = false,
        sort_by = "relative_directory",
      },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = true,
    keys = {
      { "<leader>uC", function() require("nvim-highlight-colors").toggle() end, desc = "colorizer" },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "latte",
      transparent_background = true,
      integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        gitsigns = true,
        harpoon = true,
        mini = {
          enabled = true,
          indentscope_color = "peach",
        },
        neogit = true,
        noice = false,
        notify = true,
        nvimtree = true,
        telescope = {
          enabled = true,
        },
        treesitter = true,
        treesitter_context = true,
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        "Redirect Cmdline"
      },
      {
        "<leader>snl",
        function() require("noice").cmd("last") end,
        desc =
        "Noice Last Message"
      },
      {
        "<leader>snh",
        function() require("noice").cmd("history") end,
        desc =
        "Noice History"
      },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      {
        "<leader>snd",
        function() require("noice").cmd("dismiss") end,
        desc =
        "Dismiss All"
      },
      {
        "<c-f>",
        function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
        silent = true,
        expr = true,
        desc =
        "Scroll forward",
        mode = {
          "i", "n", "s"
        }
      },
      {
        "<c-b>",
        function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
        silent = true,
        expr = true,
        desc =
        "Scroll backward",
        mode = {
          "i", "n", "s"
        }
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = true,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      style = "night",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        plugins = {
          wezterm = {
            enabled = true,
            font = "+2",
          },
        },
        window = {
          width = 0.77,
        },
      })
    end,
    keys = {
      { "<leader>Z", "<cmd>ZenMode<cr>", desc = " zen" },
    },
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      -- ascii-image-converter bruce-matlocktheartist_200w.png -b --dither -H 22
      -- Text generated with figlet.
      -- Joined with custom python.
      -- More in commons/img/dash
      local logo = [[
                           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⣔⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                           ⠀⠀⠀⠀⠀⠀⠀⠀⢐⢁⢁⡡⡘⣌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                           ⠀⠀⠀⠀⠀⠀⠀⠀⢈⢐⢐⠥⣭⢑⡈⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠠⡁⠀
                           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠪⡐⣨⡪⢇⢆⠀⠀⠀⠀⠀⠀⠀⠠⢓⢄⢜⠂⠀
                           ⠀⠀⠀⠠⡀⡀⠀⠀⠀⠀⢐⠡⢪⠽⡕⠅⡄⡀⠀⠀⠀⠀⢠⢱⢈⠮⡠⠀
                           ⠀⠀⠀⢈⠢⠪⡐⠄⠄⢢⠠⠨⡐⡕⡌⡎⡪⡸⠨⡢⡄⠀⠘⢜⡰⡡⠈⠀
                           ⠀⠀⢀⡐⠡⠅⠢⠨⢸⢨⢪⢰⢱⢱⢱⢱⢑⠁⠅⡪⢪⡲⡀⢕⠀⣇⠀⠀
                           ⠀⠀⠠⠡⠁⢨⢨⠀⢇⢎⢎⢪⢪⢺⢸⠸⡐⠀⠁⢌⢊⠪⡢⡱⡑⣮⠀⠀
         d8b               ⠀⠀⠀⡣⢨⢘⢆⠂⢕⢕⢕⢜⢜⢜⢥⠣⡣⢁⠀⠀⠂⠡⠁⡳⢨⢺⠕⠀           d8,
         88P               ⠀⡸⠠⡹⡐⢅⠂⠁⢂⢇⢇⢇⢇⠇⡧⡑⢜⢐⠀⢐⠀⠀⠰⡹⠐⣵⡑⠀          `8P
        d88                ⠀⢘⠠⠙⠌⠀⠀⠀⠀⠣⡃⡎⣆⢣⠣⡪⢘⠀⢀⠆⠀⠀⠀⠈⠌⢔⠅⠀
        888   d8888b d8888b⠀⠀⠈⠀⠀⠀⠀⠀⠀⢣⠱⡸⡰⡘⡌⡎⡆⠂⠨⠀⠀⠀⠀⠀⠀⠀⠀⠀?88   d8P  88b  88bd8b,d88b
        ?88  d8b_,dPd8b_,dP⠀⠀⠀⠀⠀⠀⠀⠀⠀⡢⡃⡇⡎⢎⡪⡪⡸⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀d88  d8P'  88P  88P'`?8P'?8b
         88b 88b    88b    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢌⠪⡪⢪⠨⢆⢗⢪⠂⠈⡂⠀⠀⠀⠀⠀⠀⠀⠀?8b ,88'  d88  d88  d88  88P
          88b`?888P'`?888P'⠀⠀⠀⠀⠀⠀⠀⠀⠐⢌⠢⡣⡱⡸⡸⢜⢎⡊⠀⡂⠀⠀⠀⠀⠀⠀⠀⠀`?888P'  d88' d88' d88'  88b
                           ⠀⠀⠀⠀⠀⠀⠀⡐⢌⡢⡑⡱⡡⡒⡌⢆⠧⡬⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀
                           ⠀⠀⠀⠀⠀⢀⠢⡱⡨⢢⢑⢌⢪⢨⢢⢣⢫⢪⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                           ⠀⠀⠀⠀⢀⢆⡇⡎⡸⣐⠡⢐⠜⡌⡎⡪⡪⡣⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀
      ]]
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("/", "  " .. "Grep", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("f", "  " .. "Files", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>"),
        dashboard.button("g", "  " .. "Git Files", "<cmd>Telescope git_files<cr>"),
        -- dashboard.button("h", "  " .. "Neovim Help", "<cmd>help<cr>"),
        dashboard.button("l", "  " .. "Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", "  " .. "Quit", ":qa<cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 2
      dashboard.section.footer.val = "Use <spc>sk for shortcuts."
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function() require("lazy").show() end,
        })
      end
      require("alpha").setup(dashboard.opts)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function() vim.g.mkdp_refresh_slow = 1 end,
  },
  {
    "junegunn/vim-easy-align",
    -- TODO: Switch to mini.align.
  },
  -- Follow:
  -- https://github.com/krivahtoo/silicon.nvim/issues/39
  -- https://github.com/krivahtoo/silicon.nvim/issues/40
  -- {
  --   "krivahtoo/silicon.nvim",
  --   build = "./install.sh build",
  --   opts = {
  --     font = "VictorMono NF=26",
  --     background = "#fff",
  --     theme = "tokyonight_night",
  --     line_number = true,
  --     pad_vert = 40,
  --     pad_horiz = 20,
  --     watermark = {
  --       text = " @theherk",
  --     },
  --     window_title = function() return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.") end,
  --   },
  -- },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons").icons
      local Util = require("config.util")
      local custom = require("lualine.themes.tokyonight")
      custom.normal.c.bg = "none"
      return {
        options = {
          theme = custom,
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              separator = { left = "" },
              right_padding = 2,
            },
          },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 4, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
              padding = { left = 1, right = 0 },
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = Util.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              function() return " " .. os.date("%R") end,
              separator = { right = "" },
              left_padding = 2,
            },
          },
        },
      }
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>um",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "dismiss messages",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("config.util").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, buffer) end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("config.icons").icons.kinds,
      }
    end,
  },
}
