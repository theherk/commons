local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add({ source = "kevinhwang91/nvim-bqf" })
  require("bqf").setup()
end)

later(function() require("mini.ai").setup() end)

later(function() require("mini.align").setup() end)

later(function()
  require("mini.bufremove").setup()
  vim.keymap.set("n", "<d-w>", function() require("mini.bufremove").delete(0, false) end, { desc = "delete buffer" })
  vim.keymap.set("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "delete buffer" })
  vim.keymap.set("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "delete buffer (force)" })
end)

later(function() require("mini.comment").setup() end)

now(function() require("mini.extra").setup() end)

now(function()
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

now(function()
  local minipick = require("mini.pick")
  local choose_all = function()
    local mappings = minipick.get_picker_opts().mappings
    vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
  end
  minipick.setup({
    mappings = { choose_all = { char = "<C-q>", func = choose_all } },
  })
  vim.ui.select = minipick.ui_select
  vim.keymap.set("n", "<d-p>", "<cmd>Pick files<cr>", { desc = "files" })
  vim.keymap.set("n", "<leader><leader>", "<cmd>Pick git_files<cr>", { desc = "git files" })
  vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "grep" })
  vim.keymap.set("n", "<leader>bb", "<cmd>Pick buffers<cr>", { desc = "buffers" })
  vim.keymap.set("n", "<leader>cs", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "document symbols" })
  vim.keymap.set("n", "<leader>cS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "workspace symbols" })
  vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "files" })
  vim.keymap.set("n", "<leader>fg", "<cmd>Pick git_files<cr>", { desc = "git files" })
  vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "help" })
  vim.keymap.set("n", "<leader>sk", "<cmd>Pick keymaps<cr>", { desc = "keymaps" })
  vim.keymap.set("n", "<leader>ss", "<cmd>Pick buf_lines<cr>", { desc = "buffer / swiper" })
  vim.keymap.set("n", "g/", "<cmd>Pick grep_live<cr>", { desc = "grep" })
end)

-- TODO: snippets
-- later(function() require("mini.snippets").setup() end)

later(function() require("mini.surround").setup() end)

later(function()
  local visits = require("mini.visits")
  visits.setup()
  vim.keymap.set("n", "<leader>fll", "<cmd>Pick visit_labels<cr>", { desc = "labels" })
  vim.keymap.set("n", "<leader>fla", function() visits.add_label() end, { desc = "add label" })
  vim.keymap.set("n", "<leader>flr", function() visits.remove_label() end, { desc = "remove lable" })
  vim.keymap.set("n", "<leader>fv", "<cmd>Pick visit_paths<cr>", { desc = "visits" })
end)

now(function() add({ source = "MunifTanjim/nui.nvim" }) end)

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

-- Disable aerial until stevearc/aerial.nvim#441 is resolved.
-- later(function()
--   add({ source = "stevearc/aerial.nvim" })
--   require("aerial").setup({
--     layout = {
--       default_direction = "right",
--       placement = "edge",
--       width = 44,
--     },
--     on_attach = function(bufnr)
--       vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
--       vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
--     end,
--   })
--   vim.keymap.set("n", "<leader>co", "<cmd>AerialToggle right<cr>", { desc = "outline (aerial)" })
--   vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { desc = "prev symbol" })
--   vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { desc = "next symbol" })
-- end)

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
