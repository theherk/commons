local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local Icons = require("module.icons")
local Lsp = require("module.lsp")
local Util = require("module.util")

later(function()
  add({ source = "aaronik/treewalker.nvim" })
  require("treewalker").setup()
end)

later(function()
  add({
    source = "hrsh7th/nvim-cmp",
    depends = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
  })
  local cmp = require("cmp")
  local defaults = require("cmp.config.default")()
  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = function()
      vim.schedule(function()
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
end)

later(function()
  add({ source = "MeanderingProgrammer/render-markdown.nvim" })
  require("render-markdown").setup({
    code = {
      border = "none",
      conceal_delimiters = false,
    },
    completions = { lsp = { enabled = true } },
    heading = {
      enabled = false,
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
    },
  })
  require("neogit").setup({
    disable_insert_on_commit = false,
    git_services = {
      ["dnb.ghe.com"] = {
        pull_request = "https://${host}/${owner}/${repository}/compare/${branch_name}?expand=1",
        commit = "https://${host}/${owner}/${repository}/commit/${oid}",
        tree = "https://${host}/${owner}/${repository}/tree/${branch_name}",
      },
      ["github.com"] = {
        pull_request = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        commit = "https://github.com/${owner}/${repository}/commit/${oid}",
        tree = "https://${host}/${owner}/${repository}/tree/${branch_name}",
      },
      ["gitlab.com"] = {
        pull_request = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        commit = "https://gitlab.com/${owner}/${repository}/-/commit/${oid}",
        tree = "https://gitlab.com/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
      },
      ["gitlab.tech.dnb.no"] = {
        pull_request = "https://gitlab.tech.dnb.no/${path}/${repository}/-/merge_requests/new?merge_request[source_branch]=${branch_name}",
        commit = "https://gitlab.tech.dnb.no/${path}/${repository}/-/commit/${oid}",
        tree = "https://gitlab.tech.dnb.no/${path}/${repository}/-/tree/${branch_name}?ref_type=heads",
      },
    },
    graph_style = "unicode",
    use_per_project_settings = true,
  })
  vim.keymap.set("n", "<leader>gG", "<cmd>Neogit<cr>", { desc = "neogit" })
end)

later(function()
  add("echasnovski/mini-git")
  require("mini.git").setup()
end)

later(function()
  add("echasnovski/mini.diff")
  local diff = require("mini.diff")
  diff.setup({
    source = diff.gen_source.none(),
  })
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
        ["dnb%.ghe%.com"] = routers.github_browse,
        ["gitlab%.tech%.dnb%.no"] = routers.gitlab_browse,
      },
      file = {
        ["gitlab%.com"] = file_path,
        ["gitlab%.tech%.dnb%.no"] = file_path,
        ["dnb%.ghe%.com"] = file_path,
        ["^github%.com"] = file_path,
      },
      repo = {
        ["gitlab%.com"] = repo_path,
        ["gitlab%.tech%.dnb%.no"] = repo_path,
        ["dnb%.ghe%.com"] = repo_path,
        ["^github%.com"] = repo_path,
      },
    },
    mappings = nil,
  })
  local function gitlink_with_tardis(opts)
    opts = opts or {}
    local bufname = vim.api.nvim_buf_get_name(0)
    local filename, revision = bufname:match("^(.+)%s+%((.+)%)$")
    if filename and revision then
      -- Get the full commit hash from the short revision
      local Job = require("plenary.job")
      local job = Job:new({
        command = "git",
        args = { "rev-parse", revision },
        cwd = vim.fn.fnamemodify(filename, ":h"),
      })
      local result = job:sync()
      if result and result[1] then
        local full_hash = result[1]
        local root_job = Job:new({
          command = "git",
          args = { "rev-parse", "--show-toplevel" },
          cwd = vim.fn.fnamemodify(filename, ":h"),
        })
        local root_result = root_job:sync()
        if root_result and root_result[1] then
          local git_root = root_result[1]
          local rel_path = filename:sub(#git_root + 2)
          opts.file = rel_path
          opts.rev = full_hash
        end
      end
    end
    gitlinker.link(opts)
  end
  vim.keymap.set({ "n", "v" }, "<leader>glr", function() gitlink_with_tardis({ router_type = "repo" }) end, { desc = "repo yank" })
  vim.keymap.set({ "n", "v" }, "<leader>glR", function() gitlink_with_tardis({ router_type = "repo", action = actions.system }) end, { desc = "repo open" })
  vim.keymap.set({ "n", "v" }, "<leader>glf", function() gitlink_with_tardis({ router_type = "file" }) end, { desc = "file yank" })
  vim.keymap.set({ "n", "v" }, "<leader>glF", function() gitlink_with_tardis({ router_type = "file", action = actions.system }) end, { desc = "file open" })
  vim.keymap.set({ "n", "v" }, "<leader>gll", function() gitlink_with_tardis({ router_type = "browse" }) end, { desc = "lines yank" })
  vim.keymap.set({ "n", "v" }, "<leader>glL", function() gitlink_with_tardis({ router_type = "browse", action = actions.system }) end, { desc = "lines open" })
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
      -- Disable formatting in bash-language-server
      on_attach = function(client, bufnr)
        -- This is to allow shfmt to take precedence.
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        ---@diagnostic disable-next-line: undefined-global
        on_attach(client, bufnr)
      end,
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
    vim.lsp.config(server, opts)
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
