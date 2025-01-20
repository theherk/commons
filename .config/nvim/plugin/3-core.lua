local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function() require("mini.ai").setup() end)

later(function() require("mini.align").setup() end)

later(function()
  require("mini.bufremove").setup()
  vim.keymap.set("n", "<d-w>", function() require("mini.bufremove").delete(0, false) end, { desc = "delete buffer" })
  vim.keymap.set("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "delete buffer" })
  vim.keymap.set("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "delete buffer (force)" })
end)

later(function() require("mini.comment").setup() end)

later(function()
  local minifiles = require("mini.files")
  minifiles.setup({
    mappings = { go_in_plus = "<cr>" },
    windows = { width_focus = 28, width_nofocus = 16 },
  })
  vim.keymap.set("n", "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, { desc = "explore" })
  vim.keymap.set("n", "<leader>fe", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, { desc = "explore" })
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args) vim.keymap.set("n", "<esc>", minifiles.close, { buffer = args.data.buf_id }) end,
  })
end)

later(function()
  local minijump = require("mini.jump")
  minijump.setup()
  vim.api.nvim_set_hl(0, "MiniJump", { link = "IncSearch" })
  vim.keymap.set({ "i", "n" }, "<esc>", function()
    if minijump.state.jumping then vim.cmd("doautocmd CursorMoved") end
    vim.cmd("noh")
    if vim.fn.mode() == "i" then
      local key = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
      vim.api.nvim_feedkeys(key, "n", false)
    end
  end, { desc = "clear" })
end)

later(function()
  local minijump2d = require("mini.jump2d")
  minijump2d.setup({
    view = {
      dim = true,
      n_steps_ahead = 1,
    },
  })
  vim.keymap.set("n", "<cr>", function() minijump2d.start(minijump2d.builtin_opts.word_start) end, { desc = "jump to word" })
  vim.keymap.set("n", "<leader>sj", minijump2d.start, { desc = "jump anywhere" })
  vim.keymap.set("n", "<leader>sl", function() minijump2d.start(minijump2d.builtin_opts.line_start) end, { desc = "jump to line" })
  vim.keymap.set("n", "<leader>sq", function() minijump2d.start(minijump2d.builtin_opts.query) end, { desc = "jump by query" })
  vim.keymap.set("n", "<leader>sw", function() minijump2d.start(minijump2d.builtin_opts.word_start) end, { desc = "jump to word" })
end)

now(function()
  local mininotify = require("mini.notify")
  mininotify.setup()
  vim.notify = mininotify.make_notify()
  vim.keymap.set("n", "<leader>sna", function() mininotify.show_history() end, { desc = "notifications" })
  vim.keymap.set("n", "<leader>snc", function() mininotify.clear() end, { desc = "clear notifications" })
end)

later(function() require("mini.pairs").setup() end)

later(function()
  local minipick = require("mini.pick")
  minipick.setup()

  vim.ui.select = minipick.ui_select
  vim.keymap.set("n", "<d-p>", "<cmd>Pick files<cr>", { desc = "files" })
  vim.keymap.set("n", "<leader><leader>", "<cmd>Pick files<cr>", { desc = "files" })
  vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "grep" })
  vim.keymap.set("n", "<leader>bb", "<cmd>Pick buffers<cr>", { desc = "buffers" })
  -- vim.keymap.set("n", "<leader>cs", "<cmd>Pick lsp_document_symbols<cr>", { desc = "document symbols" })
  -- vim.keymap.set("n", "<leader>cS", "<cmd>Pick lsp_dynamic_workspace_symbols<cr>", { desc = "workspace symbols" })
  vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "files" })
  vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "help" })
  vim.keymap.set("n", "<leader>sk", function()
    local keymaps = {}
    for _, keymap in ipairs(vim.api.nvim_get_keymap("")) do
      if keymap.desc then table.insert(keymaps, string.format("%-15s %-30s %s", keymap.mode, keymap.lhs:gsub("%s", "<Space>"), keymap.desc)) end
    end
    minipick.start({
      source = {
        items = keymaps,
        name = "Keymaps",
      },
    })
  end, { desc = "keymaps" })
  vim.keymap.set("n", "<leader>ss", function()
    local items = {}
    local line_map = {}
    local line_count = vim.api.nvim_buf_line_count(0)
    for i = 1, line_count do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
      if line and line ~= "" then
        local display = string.format("%4d: %s", i, line)
        table.insert(items, display)
        line_map[display] = i
      end
    end
    minipick.start({
      source = {
        items = items,
        name = "Buffer Lines",
      },
      act = function(selected)
        local line_nr = line_map[selected]
        if line_nr then vim.api.nvim_win_set_cursor(0, { line_nr, 0 }) end
      end,
    })
  end, { desc = "buffer / swiper" })
  vim.keymap.set("n", "g/", "<cmd>Pick grep_live<cr>", { desc = "grep" })
end)

-- TODO: snippets
-- later(function() require("mini.snippets").setup() end)

later(function() require("mini.surround").setup() end)

now(function() add({ source = "MunifTanjim/nui.nvim" }) end)

now(function() add({ source = "nvim-lua/plenary.nvim" }) end)

later(function()
  add({
    source = "nvim-neo-tree/neo-tree.nvim",
    depends = {
      "echasnovski/mini.icons",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  })
  require("neo-tree").setup({
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
  })
  vim.keymap.set("n", "<d-b>", "<cmd>Neotree toggle<cr>", { desc = "toggle neotree" })
  vim.keymap.set("n", "<ds-e>", "<cmd>Neotree toggle<cr>", { desc = "toggle neotree" })
end)

now(function()
  add({
    source = "ThePrimeagen/harpoon",
    checkout = "harpoon2",
    depends = { "nvim-lua/plenary.nvim" },
  })
  local harpoon = require("harpoon")
  harpoon:setup({
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  })
  vim.keymap.set("n", "<leader>f1", function() harpoon:list():select(1) end, { desc = "harpoon file 1" })
  vim.keymap.set("n", "<leader>f2", function() harpoon:list():select(2) end, { desc = "harpoon file 2" })
  vim.keymap.set("n", "<leader>f3", function() harpoon:list():select(3) end, { desc = "harpoon file 3" })
  vim.keymap.set("n", "<leader>f4", function() harpoon:list():select(4) end, { desc = "harpoon file 4" })
  vim.keymap.set("n", "<leader>f5", function() harpoon:list():select(5) end, { desc = "harpoon file 5" })
  vim.keymap.set("n", "<leader>f6", function() harpoon:list():select(6) end, { desc = "harpoon file 6" })
  vim.keymap.set("n", "<leader>f7", function() harpoon:list():select(7) end, { desc = "harpoon file 7" })
  vim.keymap.set("n", "<leader>f8", function() harpoon:list():select(8) end, { desc = "harpoon file 8" })
  vim.keymap.set("n", "<leader>f9", function() harpoon:list():select(9) end, { desc = "harpoon file 9" })
  vim.keymap.set("n", "<leader>fl", function() harpoon:toggle_quick_menu() end, { desc = "harpoon list" })
  vim.keymap.set("n", "<leader>fm", function() harpoon:list():add() end, { desc = "harpoon mark" })
  vim.keymap.set("n", "<leader>fn", function() harpoon:list():next() end, { desc = "harpoon next" })
  vim.keymap.set("n", "<leader>fp", function() harpoon:list():prev() end, { desc = "harpoon prev" })
  vim.keymap.set({ "i", "n" }, "<c-1>", function() harpoon:list():select(1) end, { desc = "harpoon file 1" })
  vim.keymap.set({ "i", "n" }, "<c-2>", function() harpoon:list():select(2) end, { desc = "harpoon file 2" })
  vim.keymap.set({ "i", "n" }, "<c-3>", function() harpoon:list():select(3) end, { desc = "harpoon file 3" })
  vim.keymap.set({ "i", "n" }, "<c-4>", function() harpoon:list():select(4) end, { desc = "harpoon file 4" })
  vim.keymap.set({ "i", "n" }, "<c-5>", function() harpoon:list():select(5) end, { desc = "harpoon file 5" })
  vim.keymap.set({ "i", "n" }, "<c-6>", function() harpoon:list():select(6) end, { desc = "harpoon file 6" })
  vim.keymap.set({ "i", "n" }, "<c-7>", function() harpoon:list():select(7) end, { desc = "harpoon file 7" })
  vim.keymap.set({ "i", "n" }, "<c-8>", function() harpoon:list():select(8) end, { desc = "harpoon file 8" })
  vim.keymap.set({ "i", "n" }, "<c-9>", function() harpoon:list():select(9) end, { desc = "harpoon file 9" })
  vim.keymap.set({ "i", "n" }, "<c-,>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon list" })
  vim.keymap.set("n", "]f", function() harpoon:list():next() end, { desc = "harpoon next" })
  vim.keymap.set("n", "[f", function() harpoon:list():prev() end, { desc = "harpoon prev" })
end)

later(function()
  add({ source = "voldikss/vim-browser-search" })
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
  vim.keymap.set("n", "<leader>sb", ":BrowserSearch<space>", { desc = "browser" })
  vim.keymap.set("n", "<cs-b>", "<Plug>SearchNormal", { desc = "browser search" })
  vim.keymap.set("v", "<cs-b>", "<Plug>SearchVisual", { desc = "browser search" })
end)
