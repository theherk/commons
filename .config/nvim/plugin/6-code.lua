local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local Icons = require("module.icons")
local Lsp = require("module.lsp")
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
    depends = {
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
      ["<c-space>"] = cmp.mapping.complete(),
      ["<c-backspace>"] = cmp.mapping.abort(),
      ["<c-e>"] = cmp.mapping.confirm({ select = true }),
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
      "echasnovski/mini.pick",
    },
    hooks = {
      post_checkout = function()
        local Job = require("plenary.job")
        ---@diagnostic disable-next-line: missing-fields
        Job:new({
          command = "make",
          args = {},
          cwd = vim.fn.stdpath("data") .. "/site/pack/deps/opt/avante.nvim",
          on_exit = function(j, return_val)
            if return_val ~= 0 then vim.notify("avante.nvim make install failed", vim.log.levels.ERROR) end
          end,
          on_stderr = function(_, data)
            if data then vim.notify("avante.nvim make error: " .. data, vim.log.levels.ERROR) end
          end,
        }):sync()
      end,
    },
  })
end)

later(function()
  add({ source = "zbirenbaum/copilot.lua" })
  add({ source = "zbirenbaum/copilot-cmp" })
  require("copilot_cmp").setup()
end)

later(function()
  add({ source = "HakonHarnes/img-clip.nvim" })
  require("img-clip").setup()
end)

later(function()
  add({ source = "MeanderingProgrammer/render-markdown.nvim" })
  require("render-markdown").setup({
    heading = {
      icons = { "█ ", "██ ", "▓▓▓ ", "▒▒▒▒ ", "░░░░░ ", "░░░░░░ " },
      backgrounds = {},
      position = "inline",
    },
  })
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
  require("avante").setup({
    file_selector = { provider = "mini.pick" },
    windows = { sidebar_header = { enabled = false } },
  })
end)

now(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = { "williamboman/mason.nvim" },
  })
end)

now(function()
  add({
    source = "williamboman/mason.nvim",
    depends = {
      "williamboman/mason-lspconfig.nvim",
    },
  })
  require("mason").setup({
    ensure_installed = {
      "bash-language-server",
      "flake8",
      "prettierd",
      "ruff",
      "shfmt",
      "stylua",
      "terraform-ls",
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
      "terraform",
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
    modules = {},
    sync_install = false,
    ignore_install = {},
    auto_install = true,
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
      ["gitlab.tech.dnb.no"] = "https://gitlab.tech.dnb.no/${path}/${repository}/-/merge_requests/new?merge_request[source_branch]=${branch_name}",
    },
    graph_style = "unicode",
    use_per_project_settings = true,
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
  local base_path = "https://{_A.HOST}/"
  local repo_path = base_path .. "{_A.ORG}/{_A.REPO}/"
  local file_path = repo_path .. "blob/{_A.REV}/{_A.FILE}"
  gitlinker.setup({
    router = {
      browse = {
        ["dnb%.ghe%.no"] = routers.github_browse,
        ["gitlab%.tech%.dnb%.no"] = routers.gitlab_browse,
      },
      file = {
        ["gitlab%.com"] = file_path,
        ["gitlab%.tech%.dnb%.no"] = file_path,
        ["dnb%.ghe%.no"] = file_path,
        ["^github%.com"] = file_path,
      },
      repo = {
        ["gitlab%.com"] = repo_path,
        ["gitlab%.tech%.dnb%.no"] = repo_path,
        ["dnb%.ghe%.no"] = repo_path,
        ["^github%.com"] = repo_path,
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
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "DiffviewFiles",
    callback = function(event) vim.keymap.set("n", "q", close_cmd, { desc = "close", buffer = event.buf }) end,
  })
end)

later(function()
  add({ source = "stevearc/dressing.nvim" })
  require("dressing").setup({
    select = { enabled = false },
  })
end)

later(function()
  add({
    source = "nvimtools/none-ls.nvim",
    depends = {
      "nvim-lua/plenary.nvim",
    },
  })

  local lsp = require("module.lsp")

  -- LSP Configuration
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          completion = {
            callSnippet = "Replace",
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          checkOnSave = {
            allFeatures = true,
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
        },
      },
    },
    gopls = {
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    },
    ruff = {
      settings = {
        format = {
          args = {},
        },
      },
    },
    pyright = {
      settings = {
        pyright = {
          -- Disable pyright's import organizer in favor of ruff
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Disable pyright's linting in favor of ruff
            ignore = { "*" },
          },
        },
      },
    },
    jsonls = {},
    bashls = {
      filetypes = { "sh", "bash" },
    },
    terraformls = {
      filetypes = { "terraform", "tf", "terraform-vars" },
    },
    yamlls = {
      settings = {
        yaml = {
          keyOrdering = false,
          format = { enable = true },
          validate = true,
          schemaStore = {
            enable = false,
            url = "",
          },
        },
      },
    },
  }

  -- LSP keymaps
  vim.keymap.set("n", "<leader>cf", function() Lsp.format({ force = true }) end, { desc = "format" })
  vim.keymap.set("n", "<leader>tf", function() Lsp.toggle() end, { desc = "format on save" })
  local function on_attach(_, bufnr)
    local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

    map("n", "gd", vim.lsp.buf.definition, "goto def")
    map("n", "gr", vim.lsp.buf.references, "goto refs")
    map("n", "gD", vim.lsp.buf.declaration, "goto decl")
    map("n", "gI", vim.lsp.buf.implementation, "goto impl")
    map("n", "K", vim.lsp.buf.hover, "hover")
    map("n", "<leader>cF", function() lsp.format({ force = true }) end, "format (direct)")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
    map("n", "<leader>cr", vim.lsp.buf.rename, "rename")
  end

  -- Setup Mason
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
  })

  -- Setup LSP with shared configs
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  for server, opts in pairs(servers) do
    opts.capabilities = capabilities
    opts.on_attach = on_attach
    require("lspconfig")[server].setup(opts)
  end

  -- Setup null-ls
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      -- Formatters
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.terraform_fmt,

      -- Diagnostics
      null_ls.builtins.diagnostics.fish,
      null_ls.builtins.diagnostics.hadolint,
    },
  })

  -- Format on save
  lsp.opts = {
    autoformat = true,
    format_notify = false,
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("Format", {}),
    callback = function()
      if lsp.opts.autoformat then lsp.format() end
    end,
  })

  -- Diagnostic config
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
  })
end)

later(function() Util.ai_update_services() end)
