return {
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
      flavour = "frappe",
      transparent_background = true,
      integrations = {
        alpha = true,
        cmp = true,
        dap = true,
        dap_ui = true,
        gitsigns = true,
        grug_far = true,
        harpoon = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "peach",
        },
        navic = {
          enabled = false,
          custom_bg = "NONE",
        },
        neogit = true,
        neotree = true,
        noice = true,
        notify = true,
        nvimtree = true,
        render_markdown = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  { "RRethy/base16-nvim" },
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
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
    enabled = not vim.g.started_by_firenvim,
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
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          position = {
            row = 16,
            col = "50%",
          },
          size = {
            min_width = 60,
            width = "auto",
            height = "auto",
          },
        },
        cmdline_popupmenu = {
          relative = "editor",
          position = {
            row = 19,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
            max_height = 15,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
          },
        },
      },
    },
    keys = {
      { "<s-enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", "noice redirect cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "noice all" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "noice dismiss" },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "scroll backward",
        mode = { "i", "n", "s" },
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
            font = "+3",
          },
        },
        window = {
          options = {
            number = false,
            cursorline = false,
          },
          width = 0.77,
        },
      })
    end,
    keys = {
      { "<leader>Z", "<cmd>ZenMode<cr>", desc = "zen" },
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
      local buttons = {
        dashboard.button("f", "  " .. "files", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>"),
        dashboard.button("g", "󰊢  " .. "git files", "<cmd>Telescope git_files<cr>"),
      }
      if vim.g.neovide then
        table.insert(buttons, 1, dashboard.button("p", "  " .. "projects", "<cmd>ProjectExplorer<cr>"))
      else
        table.insert(buttons, 1, dashboard.button("/", "  " .. "grep", "<cmd>Telescope live_grep<cr>"))
      end
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = buttons
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
  -- https://github.com/krivahtoo/silicon.nvim/issues/54
  -- {
  --   "krivahtoo/silicon.nvim",
  --   build = "./install.sh build",
  --   opts = {
  --     font = "VictorMono NF=26",
  --     background = "#414559",
  --     theme = "Catppuccin-frappe",
  --     line_number = true,
  --     pad_vert = 40,
  --     pad_horiz = 20,
  --     watermark = {
  --       text = " @theherk",
  --     },
  --     window_title = function() return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.") end,
  --   },
  -- },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    main = "nvim-silicon",
    opts = {
      background = "#414559",
      font = "VictorMono NF=26",
      pad_horiz = 20,
      pad_vert = 40,
      theme = "Catppuccin-frappe",
      to_clipboard = true,
      window_title = function() return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.") end,
    },
  },
  {
    "mawkler/modicator.nvim",
    config = true,
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-lualine/lualine.nvim",
    enabled = not vim.g.started_by_firenvim,
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons").icons
      local Util = require("config.util")
      local custom = require("lualine.themes.catppuccin")
      custom.normal.c.bg = "none"
      return {
        options = {
          theme = custom,
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode" } },
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
            { "filetype", icon_only = true },
            { "filename", path = 4, separator = { right = "▷" }, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            },
          },
          lualine_x = {
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = Util.fg("Statement"),
            },
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
            { "diff", symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed } },
          },
          lualine_y = {
            { "progress" },
            { "location" },
            {
              function()
                if not vim.g.neovide then return "" end
                local root = Util.get_root()
                if root then
                  local repo_name = root:match("[^/]+$")
                  return "󱂬 " .. repo_name
                end
                return ""
              end,
            },
          },
          lualine_z = { { function() return " " .. os.date("%R") end } },
        },
      }
    end,
  },
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
    opts = {
      separator = " ",
      highlight = true,
      depth_limit = 5,
      icons = require("config.icons").icons.kinds,
    },
  },
}
