local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local Icons = require("module.icons")
local Util = require("module.util")

-- Much of the ai configuration is happening on the fly, so you'll find
-- it in the pcalls in module/util.lua.

later(function()
  add({ source = "aaronik/treewalker.nvim" })
  require("treewalker").setup()
end)

later(function()
  add({
    source = "hrsh7th/nvim-cmp",
    depend = {
      "Exafunction/codeium.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot.lua",
      "zbirenbaum/copilot-cmp",
    },
  })
  local cmp = require("cmp")
  local defaults = require("cmp.config.default")()
  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = function()
      vim.schedule(function()
        Util.ai_update_services()
        local sources = Util.get_active_sources()
        cmp.setup({ sources = cmp.config.sources(sources) })
        local source_names = vim.tbl_map(function(source) return source.name end, sources)
        local msg = table.concat(source_names, ", ")
        vim.notify(msg, vim.log.levels.INFO, { title = "cmp sources" })
      end)
    end,
  })
  local sources = cmp.config.sources(Util.get_active_sources())
  cmp.setup({
    completion = { completeopt = "menu,menuone,noinsert" },
    snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
      ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<c-b>"] = cmp.mapping.scroll_docs(-4),
      ["<c-f>"] = cmp.mapping.scroll_docs(4),
      ["<c-e>"] = cmp.mapping.complete(),
      ["<c-backspace>"] = cmp.mapping.abort(),
      ["<cr>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = sources,
    formatting = {
      format = function(_, item)
        if Icons.kinds[item.kind] then item.kind = Icons.kinds[item.kind] .. item.kind end
        return item
      end,
    },
    experimental = {
      ghost_text = {
        hl_group = "CmpGhostText",
      },
    },
    sorting = defaults.sorting,
  })
  cmp.setup.filetype("vim", {
    sources = vim.tbl_filter(function(source) return source.name ~= "codeium" end, sources),
  })
end)

later(function()
  add({
    source = "Exafunction/codeium.nvim",
    depend = { "nvim-lua/plenary.nvim" },
  })
  require("codeium").setup()
end)

later(function()
  add({
    source = "yetone/avante.nvim",
    depends = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.icons",
    },
    hooks = { post_checkout = function() vim.cmd("make") end },
  })
end)

later(function()
  add({ source = "zbirenbaum/copilot.lua" })
  require("copilot").setup({
    auth_provider_url = "https://dnb.ghe.com",
    panel = { enabled = false },
    suggestion = { enabled = false },
  })
  add({ source = "zbirenbaum/copilot-cmp" })
  require("copilot_cmp").setup()
end)

later(function()
  add({ source = "HakonHarnes/img-clip.nvim" })
  require("img-clip").setup()
end)

later(function()
  add({ source = "MeanderingProgrammer/render-markdown.nvim" })
  require("render-markdown").setup()
end)

later(function()
  add({ source = "tadmccorkle/markdown.nvim" })
  require("markdown").setup({
    mappings = {
      go_curr_heading = "[c",
      go_parent_heading = "[p",
    },
    on_attach = function(bufnr)
      vim.keymap.set({ "n", "i" }, "<d-o>", "<cmd>MDListItemBelow<cr>", { buffer = bufnr, desc = "item below" })
      vim.keymap.set({ "n", "i" }, "<d-O>", "<cmd>MDListItemAbove<cr>", { buffer = bufnr, desc = "item above" })
      vim.keymap.set({ "n", "i" }, "<m-o>", "<cmd>MDListItemBelow<cr>", { buffer = bufnr, desc = "item below" })
      vim.keymap.set({ "n", "i" }, "<m-O>", "<cmd>MDListItemAbove<cr>", { buffer = bufnr, desc = "item above" })
    end,
  })
end)

later(function()
  require("avante_lib").load()
  require("avante").setup()
end)

now(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = { "williamboman/mason.nvim" },
  })
end)

now(function()
  add({ source = "williamboman/mason.nvim" })
  require("mason").setup({
    ensure_installed = {
      "bash-language-server",
      "flake8",
      "prettierd",
      "shfmt",
      "stylua",
    },
  })
end)

later(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
  })
  require("nvim-treesitter.configs").setup({
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
      "vimdoc",
      "yaml",
    },
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "v",
        node_decremental = "V",
      },
    },
    indent = { enable = true },
  })
end)

later(function()
  add({
    source = "2kabhishek/co-author.nvim",
    depends = { "stevearc/dressing.nvim" },
  })
  vim.keymap.set("n", "<leader>gC", "<cmd>CoAuthor<cr>", { desc = "co-author" })
end)

later(function()
  add({
    source = "fredeeb/tardis.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })
  require("tardis-nvim").setup()
  vim.keymap.set("n", "<leader>gt", "<cmd>Tardis<cr>", { desc = "tardis" })
end)

later(function()
  add({
    source = "NeogitOrg/neogit",
    depends = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
  })
  require("neogit").setup({
    disable_insert_on_commit = false,
    git_services = {
      ["dnb.ghe.com"] = "https://dnb.ghe.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      ["gitlab.tech.dnb.no"] = "https://gitlab.tech.dnb.no/${path}/${repository}/-/merge_requests/new?merge_request[source_branch]=${branch_name}&merge_request[target_branch]=main",
    },
    graph_style = "unicode",
  })
  vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "neogit" })
end)

later(function()
  add("echasnovski/mini-git")
  require("mini.git").setup()
end)

later(function()
  add("echasnovski/mini.diff")
  require("mini.diff").setup()
end)

later(function()
  add({
    source = "linrongbin16/gitlinker.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })
  local gitlinker = require("gitlinker")
  local actions = require("gitlinker.actions")
  local routers = require("gitlinker.routers")
  local base_path = "{_A.PROTOCOL}://{_A.HOST}/"
  local repo_path = "{_A.ORG}/{_A.REPO}/"
  local file_path = repo_path .. "blob/{_A.REV}/{_A.FILE}"
  gitlinker.setup({
    router = {
      browse = {
        ["dnb%.ghe%.no"] = routers.github_browse,
        ["gitlab%.tech%.dnb%.no"] = routers.gitlab_browse,
      },
      file = {
        ["gitlab%.com"] = base_path .. file_path,
        ["gitlab%.tech%.dnb%.no"] = base_path .. file_path,
        ["dnb%.ghe%.no"] = base_path .. file_path,
        ["^github%.com"] = base_path .. file_path,
      },
      repo = {
        ["gitlab%.com"] = repo_path .. file_path,
        ["gitlab%.tech%.dnb%.no"] = repo_path .. file_path,
        ["dnb%.ghe%.no"] = repo_path .. file_path,
        ["^github%.com"] = repo_path .. file_path,
      },
    },
    mappings = nil,
  })
  vim.keymap.set({ "n", "v" }, "<leader>glr", function() gitlinker.link({ router_type = "repo" }) end, { desc = "repo yank" })
  vim.keymap.set({ "n", "v" }, "<leader>glR", function() gitlinker.link({ router_type = "repo", action = actions.system }) end, { desc = "repo open" })
  vim.keymap.set({ "n", "v" }, "<leader>glf", function() gitlinker.link({ router_type = "file" }) end, { desc = "file yank" })
  vim.keymap.set({ "n", "v" }, "<leader>glF", function() gitlinker.link({ router_type = "file", action = actions.system }) end, { desc = "file open" })
  vim.keymap.set({ "n", "v" }, "<leader>gll", function() gitlinker.link({ router_type = "browse" }) end, { desc = "lines yank" })
  vim.keymap.set({ "n", "v" }, "<leader>glL", function() gitlinker.link({ router_type = "browse", action = actions.system }) end, { desc = "lines open" })
end)

later(function()
  add("sindrets/diffview.nvim")
  require("diffview").setup({ enhanced_diff_hl = true })
  vim.keymap.set("n", "<leader>gdd", "<cmd>DiffviewOpen<cr>", { desc = "open diffview" })
  vim.keymap.set("n", "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", { desc = "diffview history" })
  vim.keymap.set("n", "<leader>gdl", "<cmd>DiffviewLog<cr>", { desc = "diffview log" })
  vim.keymap.set("n", "<leader>gdr", "<cmd>DiffviewRefresh<cr>", { desc = "diffview refresh" })
  local close_cmd = "<cmd>set hidden<cr><cmd>DiffviewClose<cr><cmd>set nohidden<cr>"
  vim.keymap.set("n", "q", close_cmd, { desc = "close", buffer = true })
end)
