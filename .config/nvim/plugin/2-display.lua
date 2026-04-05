local add = vim.pack.add
local now, later = Config.now, Config.later
local Icons = require("module.icons")
local Util = require("module.util")

local blink = "blinkwait777-blinkon1111-blinkoff666-Cursor"
local normal_cursor = "c-n-v-ve:block-" .. blink
local insert_cursor = "i-ci:ver25-" .. blink
local replace_cursor = "r-cr:hor20-" .. blink
local operator_cursor = "o:hor50-" .. blink
local showmatch_cursor = "sm:block-" .. blink

-- Follow: https://github.com/neovim/neovim/pull/31562
vim.o.guicursor = table.concat({
  normal_cursor,
  insert_cursor,
  replace_cursor,
  operator_cursor,
  showmatch_cursor,
}, ",")

now(function()
  add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })
  local flavour = "frappe"
  require("catppuccin").setup({
    color_overrides = { all = { green = require("catppuccin.palettes").get_palette(flavour).teal } },
    custom_highlights = function(colors)
      return {
        CmpBorder = { fg = colors.surface1 },
        FloatBorder = { fg = colors.surface1 },
      }
    end,
    flavour = flavour,
    transparent_background = true,
    integrations = {
      alpha = true,
      cmp = true,
      dap = true,
      dap_ui = true,
      gitsigns = true,
      grug_far = true,
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
      notify = true,
      nvimtree = true,
      render_markdown = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
end)

later(function()
  add({ "https://github.com/brenoprata10/nvim-highlight-colors" })
  require("nvim-highlight-colors").setup({})
  vim.keymap.set("n", "<leader>tC", require("nvim-highlight-colors").toggle, { desc = "colorizer" })
end)

now(function()
  local MiniIcons = require("mini.icons")
  MiniIcons.setup()
  MiniIcons.mock_nvim_web_devicons()
end)

now(function()
  require("mini.indentscope").setup({
    symbol = "│",
    options = { try_as_border = true },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "alpha", "help", "neo-tree", "Trouble", "mason", "notify", "toggleterm" },
    callback = function() vim.b.miniindentscope_disable = true end,
  })
end)

later(function()
  add({ "https://github.com/folke/todo-comments.nvim" })
  require("todo-comments").setup()
  vim.keymap.set("n", "<leader>st", "<cmd>TodoQuickFix<cr>", { desc = "todos" })
end)

now(function()
  add({ "https://github.com/goolord/alpha-nvim" })
  -- ascii-image-converter bruce-matlocktheartist_200w.png -b --dither -H 22
  -- Text generated with figlet.
  -- Joined with custom python.
  -- More in commons/img/dash
  local logo = table.concat({
    "                              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "                              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "                              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⣔⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "                              ⠀⠀⠀⠀⠀⠀⠀⠀⢐⢁⢁⡡⡘⣌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "                              ⠀⠀⠀⠀⠀⠀⠀⠀⢈⢐⢐⠥⣭⢑⡈⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠠⡁⠀",
    "                              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠪⡐⣨⡪⢇⢆⠀⠀⠀⠀⠀⠀⠀⠠⢓⢄⢜⠂⠀",
    "                              ⠀⠀⠀⠠⡀⡀⠀⠀⠀⠀⢐⠡⢪⠽⡕⠅⡄⡀⠀⠀⠀⠀⢠⢱⢈⠮⡠⠀",
    "                              ⠀⠀⠀⢈⠢⠪⡐⠄⠄⢢⠠⠨⡐⡕⡌⡎⡪⡸⠨⡢⡄⠀⠘⢜⡰⡡⠈⠀",
    "                              ⠀⠀⢀⡐⠡⠅⠢⠨⢸⢨⢪⢰⢱⢱⢱⢱⢑⠁⠅⡪⢪⡲⡀⢕⠀⣇⠀⠀",
    "                              ⠀⠀⠠⠡⠁⢨⢨⠀⢇⢎⢎⢪⢪⢺⢸⠸⡐⠀⠁⢌⢊⠪⡢⡱⡑⣮⠀⠀",
    "            d8b               ⠀⠀⠀⡣⢨⢘⢆⠂⢕⢕⢕⢜⢜⢜⢥⠣⡣⢁⠀⠀⠂⠡⠁⡳⢨⢺⠕⠀           d8,",
    "            88P               ⠀⡸⠠⡹⡐⢅⠂⠁⢂⢇⢇⢇⢇⠇⡧⡑⢜⢐⠀⢐⠀⠀⠰⡹⠐⣵⡑⠀          `8P",
    "           d88                ⠀⢘⠠⠙⠌⠀⠀⠀⠀⠣⡃⡎⣆⢣⠣⡪⢘⠀⢀⠆⠀⠀⠀⠈⠌⢔⠅⠀",
    "           888   d8888b d8888b⠀⠀⠈⠀⠀⠀⠀⠀⠀⢣⠱⡸⡰⡘⡌⡎⡆⠂⠨⠀⠀⠀⠀⠀⠀⠀⠀⠀?88   d8P  88b  88bd8b,d88b",
    "           ?88  d8b_,dPd8b_,dP⠀⠀⠀⠀⠀⠀⠀⠀⠀⡢⡃⡇⡎⢎⡪⡪⡸⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀d88  d8P'  88P  88P'`?8P'?8b",
    "            88b 88b    88b    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢌⠪⡪⢪⠨⢆⢗⢪⠂⠈⡂⠀⠀⠀⠀⠀⠀⠀⠀?8b ,88'  d88  d88  d88  88P",
    "             88b`?888P'`?888P'⠀⠀⠀⠀⠀⠀⠀⠀⠐⢌⠢⡣⡱⡸⡸⢜⢎⡊⠀⡂⠀⠀⠀⠀⠀⠀⠀⠀`?888P'  d88' d88' d88'  88b",
    "                              ⠀⠀⠀⠀⠀⠀⠀⡐⢌⡢⡑⡱⡡⡒⡌⢆⠧⡬⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀",
    "                              ⠀⠀⠀⠀⠀⢀⠢⡱⡨⢢⢑⢌⢪⢨⢢⢣⢫⢪⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "                              ⠀⠀⠀⠀⢀⢆⡇⡎⡸⣐⠡⢐⠜⡌⡎⡪⡪⡣⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  }, "\n")
  local dashboard = require("alpha.themes.dashboard")
  local buttons = {
    dashboard.button("f", Icons.misc.Files .. " files", "<cmd>Pick files<cr>"),
    dashboard.button("g", Icons.misc.Git .. " git files", "<cmd>Pick git_files<cr>"),
    dashboard.button("/", Icons.misc.Find .. " grep", "<cmd>Pick grep_live<cr>"),
    dashboard.button("q", Icons.misc.Quit .. " quit", "<cmd>qall<cr>"),
  }
  dashboard.section.header.val = vim.split(logo, "\n")
  dashboard.section.buttons.val = buttons
  for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
    button.opts.width = 22
  end
  dashboard.section.header.opts.hl = "AlphaHeader"
  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.section.footer.opts.hl = "AlphaFooter"
  dashboard.opts.layout[1].val = 2
  dashboard.section.footer.val = "Be like water..."
  if vim.env.NVIM_NEOGIT ~= "1" then
    require("alpha").setup(dashboard.opts)
  end
end)

later(function()
  add({ { src = "https://github.com/iamcco/markdown-preview.nvim", name = "markdown-preview" } })
  vim.g.mkdp_refresh_slow = 1
end)

now(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      { mode = "n", keys = "<leader><tab>", desc = "tab" },
      { mode = "n", keys = "<leader>a", desc = "ai" },
      { mode = "v", keys = "<leader>a", desc = "ai" },
      { mode = "n", keys = "<leader>b", desc = "buffer" },
      { mode = "n", keys = "<leader>c", desc = "code" },
      { mode = "n", keys = "<leader>d", desc = "debug" },
      { mode = "n", keys = "<leader>dP", desc = "python" },
      { mode = "n", keys = "<leader>f", desc = "file" },
      { mode = "n", keys = "<leader>fl", desc = "label" },
      { mode = "n", keys = "<leader>g", desc = "git" },
      { mode = "v", keys = "<leader>g", desc = "git" },
      { mode = "n", keys = "<leader>gd", desc = "diffview" },
      { mode = "n", keys = "<leader>gl", desc = "link" },
      { mode = "v", keys = "<leader>gl", desc = "link" },
      { mode = "n", keys = "<leader>h", desc = "help" },
      { mode = "n", keys = "<leader>n", desc = "notes" },
      { mode = "n", keys = "<leader>nj", desc = "journal" },
      { mode = "n", keys = "<leader>nl", desc = "link" },
      { mode = "v", keys = "<leader>nl", desc = "link" },
      { mode = "n", keys = "<leader>nw", desc = "workspace" },
      { mode = "n", keys = "<leader>s", desc = "search" },
      { mode = "n", keys = "<leader>sn", desc = "nofifications" },
      { mode = "n", keys = "<leader>st", desc = "todo" },
      { mode = "n", keys = "<leader>t", desc = "toggle" },
      { mode = "n", keys = "<leader>w", desc = "window" },
      { mode = "n", keys = "<localleader>m", desc = "mark" },
    },
    triggers = {
      { mode = "n", keys = "<c-w>" },
      { mode = "i", keys = "<c-w>" },
      { mode = "n", keys = "<leader>" },
      { mode = "v", keys = "<leader>" },
      { mode = "n", keys = "<localleader>" },
      { mode = "v", keys = "<localleader>" },
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
  })
end)

now(function()
  add({ "https://github.com/nvim-lualine/lualine.nvim" })
  local custom = require("lualine.themes.catppuccin-frappe")
  custom.normal.c.bg = "none"
  ---@diagnostic disable-next-line: undefined-field
  require("lualine").setup({
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
            error = Icons.diagnostics.Error,
            warn = Icons.diagnostics.Warn,
            info = Icons.diagnostics.Info,
            hint = Icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true },
        { "filename", path = 4, separator = { right = "▷" }, symbols = { modified = "  ", readonly = "", unnamed = "" } },
      },
      lualine_x = {
        {
          function() return Icons.misc.Bug .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = Util.fg("Debug"),
        },
        { "diff", symbols = { added = Icons.git.added, modified = Icons.git.modified, removed = Icons.git.removed } },
      },
      lualine_y = {
        { "progress" },
        { "location" },
      },
      lualine_z = {
        {
          function()
            if not vim.g.neovide then return Icons.misc.Clock .. os.date("%R") end
            local root = Util.get_root()
            if root then
              local repo_name = root:match("[^/]+$")
              return "󱂬 " .. repo_name
            end
            return ""
          end,
        },
      },
    },
  })
end)

now(function() add({ "https://github.com/nvim-lua/plenary.nvim" }) end)

now(function()
  add({
    "https://github.com/echasnovski/mini.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/willothy/nvim-cokeline",
  })
  local coke = require("module.coke")
  local hlg = require("cokeline.hlgroups")
  require("cokeline").setup({
    default_hl = {
      fg = function(buffer) return buffer.is_focused and vim.g.terminal_color_6 or hlg.get_hl_attr("Comment", "fg") end,
      bg = function(buffer) return buffer.is_focused and hlg.get_hl_attr("lualine_b_normal", "bg") or "NONE" end,
    },
    components = {
      {
        text = function(buffer) return not buffer.is_first and "|" or "" end,
        fg = function(_) return vim.g.terminal_color_4 end,
        bg = "NONE",
      },
      coke.component_gap(),
      coke.component_icon(),
      coke.component_status(),
      coke.component_name(),
      coke.component_gap(),
    },
    buffers = {
      filter_valid = function(buffer) return buffer.type ~= "terminal" and buffer.type ~= "prompt" end,
    },
    tabs = {
      placement = "right",
      components = {
        {
          text = function(tabpage)
            if vim.fn.tabpagenr("$") == 1 then return "" end
            return not tabpage.is_first and "|" or ""
          end,
          fg = function(_) return vim.g.terminal_color_4 end,
          bg = "NONE",
        },
        {
          text = function(tabpage)
            if vim.fn.tabpagenr("$") == 1 then return "" end
            local tabs = vim.api.nvim_list_tabpages()
            -- Find position of current tab in the list
            for i, tab_handle in ipairs(tabs) do
              if tab_handle == tabpage.number then return " " .. i .. " " end
            end
            return " " .. tabpage.number .. " " -- fallback
          end,
          fg = function(tabpage) return tabpage.is_active and vim.g.terminal_color_5 or hlg.get_hl_attr("Comment", "fg") end,
          bg = function(tabpage) return tabpage.is_active and hlg.get_hl_attr("lualine_b_normal", "bg") or "NONE" end,
        },
      },
    },
    sidebar = {
      filetype = { "NvimTree", "neo-tree" },
      components = {
        {
          text = "files",
          fg = vim.g.terminal_color_4,
          bg = function() return hlg.get_hl_attr("NvimTreeNormal", "bg") end,
        },
      },
    },
  })
end)
