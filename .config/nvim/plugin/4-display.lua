local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
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
  add({
    source = "catppuccin/nvim",
    name = "catppuccin",
  })
  local flavour = "frappe"
  require("catppuccin").setup({
    color_overrides = { all = { green = require("catppuccin.palettes").get_palette(flavour).teal } },
    custom_highlights = function(colors)
      return {
        CmpBorder = { fg = colors.surface1 },
        FloatBorder = { fg = colors.surface1 },
        HarpoonBorder = { fg = colors.surface1 },
        NoiceCmdlinePopupBorder = { fg = colors.overlay0 },
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
  })
  vim.cmd.colorscheme("catppuccin")
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
end)

now(function()
  add({ source = "brenoprata10/nvim-highlight-colors" })
  require("nvim-highlight-colors").setup()
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
  add({
    source = "folke/noice.nvim",
    depends = { "MunifTanjim/nui.nvim" },
  })
  local noice = require("noice")
  noice.setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = { event = "msg_show", any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" } } },
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
        position = { row = 16, col = "50%" },
        size = { min_width = 60, width = "auto", height = "auto" },
      },
      cmdline_popupmenu = {
        relative = "editor",
        position = { row = 19, col = "50%" },
        size = { width = 60, height = "auto", max_height = 15 },
        border = { style = "rounded", padding = { 0, 1 } },
        win_options = { winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" } },
      },
    },
  })
  vim.keymap.set("n", "<s-enter>", function() noice.redirect(vim.fn.getcmdline()) end, { desc = "noice redirect cmdline" })
  vim.keymap.set("n", "<leader>snl", function() noice.cmd("last") end, { desc = "noice last message" })
  vim.keymap.set("n", "<leader>snh", function() noice.cmd("history") end, { desc = "noice history" })
  vim.keymap.set("n", "<leader>sna", function() noice.cmd("all") end, { desc = "noice all" })
  vim.keymap.set("n", "<leader>snd", function() noice.cmd("dismiss") end, { desc = "noice dismiss" })
  vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
    if not require("noice.lsp").scroll(4) then return "<c-f>" end
  end, { silent = true, expr = true })
  vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
    if not require("noice.lsp").scroll(-4) then return "<c-b>" end
  end, { silent = true, expr = true })
end)

later(function()
  add({ source = "folke/todo-comments.nvim" })
  require("todo-comments").setup()
end)

now(function()
  add({ source = "goolord/alpha-nvim" })
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
  require("alpha").setup(dashboard.opts)
end)

later(function()
  add({
    source = "iamcco/markdown-preview.nvim",
    name = "markdown-preview",
    hooks = { post_checkout = function() vim.fn["mkdp#util#install"]() end },
  })
  vim.g.mkdp_refresh_slow = 1
end)

later(function()
  add({
    source = "michaelrommel/nvim-silicon",
    name = "silicon",
  })
  require("silicon").setup({
    background = "#414559",
    font = "VictorMono NF=26",
    pad_horiz = 20,
    pad_vert = 40,
    theme = "Catppuccin-frappe",
    to_clipboard = true,
    window_title = function() return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.") end,
  })
end)

later(function()
  add({ source = "mawkler/modicator.nvim" })
  require("modicator").setup()
end)

later(function()
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
      { mode = "n", keys = "<leader>b", desc = "buffer" },
      { mode = "n", keys = "<leader>c", desc = "code" },
      { mode = "n", keys = "<leader>d", desc = "debug" },
      { mode = "n", keys = "<leader>dP", desc = "python" },
      { mode = "n", keys = "<leader>f", desc = "file" },
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
      { mode = "n", keys = "<leader>N", desc = "neorg" },
      { mode = "n", keys = "<leader>Nj", desc = "journal" },
      { mode = "n", keys = "<leader>s", desc = "search" },
      { mode = "n", keys = "<leader>sn", desc = "noice" },
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
  add({ source = "nvim-lualine/lualine.nvim" })
  local custom = require("lualine.themes.catppuccin")
  custom.normal.c.bg = "none"
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

later(function()
  add({
    source = "willothy/nvim-cokeline",
    depends = {
      "echasnovski/mini.icons",
      "nvim-lua/plenary.nvim",
    },
  })
  local harpoon = require("harpoon")
  local hlg = require("cokeline.hlgroups")
  local is_picking_focus = require("cokeline.mappings").is_picking_focus
  local is_picking_close = require("cokeline.mappings").is_picking_close
  local function get_harpoon_index(path)
    local list = harpoon:list()
    for idx, item in ipairs(list.items) do
      if item.value == path then return idx end
    end
    return nil
  end
  local function harpoon_icon(buffer)
    local path = require("plenary.path"):new(buffer.path):make_relative(vim.uv.cwd())
    return get_harpoon_index(path) ~= nil and " 󰛢 " or ""
  end
  local function harpoon_sorter()
    local cache = {}
    local setup = false
    local function marknum(buf, force)
      local b = cache[buf.number]
      if b == nil or force then
        local path = require("plenary.path"):new(buf.path):make_relative(vim.uv.cwd())
        for i, mark in ipairs(harpoon:list():display()) do
          if mark == path then
            b = i
            cache[buf.number] = b
            break
          end
        end
      end
      return b
    end
    return function(a, b)
      local has_harpoon = package.loaded["harpoon"] ~= nil
      if not has_harpoon then
        ---@diagnostic disable-next-line: undefined-field
        return a._valid_index < b._valid_index
      elseif not setup then
        local refresh = function() cache = {} end
        require("harpoon"):extend({
          ADD = refresh,
          REMOVE = refresh,
          REORDER = refresh,
          LIST_CHANGE = refresh,
        })
        setup = true
      end
      local ma = marknum(a)
      local mb = marknum(b)
      if ma and not mb then
        return true
      elseif mb and not ma then
        return false
      elseif ma == nil and mb == nil then
        ma = a._valid_index
        mb = b._valid_index
      end
      return ma < mb
    end
  end
  require("cokeline").setup({
    default_hl = {
      fg = function(buffer) return buffer.is_focused and vim.g.terminal_color_6 or hlg.get_hl_attr("Comment", "fg") end,
      bg = function(buffer) return buffer.is_focused and vim.g.terminal_color_8 or "NONE" end,
    },
    components = {
      {
        text = function(buffer) return not buffer.is_first and "|" or "" end,
        fg = function(_) return vim.g.terminal_color_4 end,
        bg = "NONE",
      },
      {
        text = " ",
      },
      {
        text = function(buffer) return (is_picking_focus() or is_picking_close()) and buffer.pick_letter .. " " or buffer.devicon.icon end,
        fg = function(buffer) return (is_picking_focus() and vim.g.terminal_color_4) or (is_picking_close() and vim.g.terminal_color_1) or buffer.devicon.color end,
        italic = function() return (is_picking_focus() or is_picking_close()) end,
        bold = function() return (is_picking_focus() or is_picking_close()) end,
      },
      {
        text = harpoon_icon,
        fg = function(_) return hlg.get_hl_attr("DiagnosticWarn", "fg") end,
      },
      {
        text = function(buffer) return (buffer.is_modified and Icons.misc.Save) or (buffer.diagnostics.errors ~= 0 and Icons.diagnostics.Error) or (buffer.diagnostics.warnings ~= 0 and Icons.diagnostics.Warn) or "  " end,
        fg = function(buffer)
          if buffer.is_modified then
            return hlg.get_hl_attr("DiagnosticHint", "fg")
          elseif buffer.diagnostics.errors ~= 0 then
            return hlg.get_hl_attr("DiagnosticError", "fg")
          elseif buffer.diagnostics.warnings ~= 0 then
            return hlg.get_hl_attr("DiagnosticWarn", "fg")
          else
            return nil
          end
        end,
      },
      {
        text = function(buffer) return buffer.unique_prefix end,
        fg = function(_) return hlg.get_hl_attr("property", "fg") end,
        italic = true,
      },
      {
        text = function(buffer) return buffer.filename .. "  " end,
        bold = function(buffer) return buffer.is_focused end,
        italic = function(buffer) return not buffer.is_focused end,
        truncation = { priority = 99 },
      },
    },
    buffers = {
      new_buffers_position = harpoon_sorter(),
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
          bg = function(tabpage) return tabpage.is_active and vim.g.terminal_color_8 or "NONE" end,
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
