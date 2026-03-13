local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local Lsp = require("module.lsp")

later(function()
  add({ source = "aaronik/treewalker.nvim" })
  require("treewalker").setup()
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

later(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter.configs not found, skipping setup", vim.log.levels.WARN)
        return
      end

      configs.setup({
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
    end,
  })
end)

now(function()
  add({
    source = "fredeeb/tardis.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })
  require("tardis-nvim").setup()
  vim.keymap.set("n", "<leader>gt", "<cmd>Tardis<cr>", { desc = "tardis" })
end)

now(function()
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
  -- Launch directly if "NVIM_NEOGIT=1".
  if vim.env.NVIM_NEOGIT == "1" then
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function() require("neogit").open() end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitStatus",
      callback = function()
        vim.defer_fn(function() vim.keymap.set("n", "q", "<cmd>qa<cr>", { buffer = true, desc = "quit neovim" }) end, 100) -- Delay to ensure Neogit sets its mapping first.
      end,
    })
  end
end)

later(function()
  add("echasnovski/mini-git")
  require("mini.git").setup()
end)

later(function()
  add("echasnovski/mini.diff")
  local diff = require("mini.diff")
  diff.setup()
  vim.keymap.set("n", "<leader>go", diff.toggle_overlay, { desc = "diff overlay" })
  vim.keymap.set("n", "<leader>tD", diff.toggle, { desc = "toggle diff signs" })
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
  add({ source = "stevearc/conform.nvim" })
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      json = { "prettierd" },
      markdown = { "prettierd" },
      -- These LSP servers handle their own formatting natively:
      -- gopls (gofumpt=true + imports), ruff, terraformls, yamlls
    },
  })
end)

later(function()
  add({ source = "mfussenegger/nvim-lint" })
  require("lint").linters_by_ft = {
    fish = { "fish" },
    dockerfile = { "hadolint" },
  }
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
    callback = function() require("lint").try_lint() end,
  })
end)

later(function()
  local lsp = require("module.lsp")

  -- LSP Configuration
  local servers = {
    lua_ls = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = { vim.env.VIMRUNTIME .. "/lua" },
            checkThirdParty = "Disable",
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
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      root_markers = { "Cargo.toml", "rust-project.json", ".git" },
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
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.mod", "go.work", ".git" },
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
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = false,
        },
      },
    },
    ruff = {
      cmd = { "ruff", "server" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
      settings = {
        format = {
          args = {},
        },
      },
    },
    pyright = {
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "pyrightconfig.json", ".git" },
      settings = {
        pyright = {
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            ignore = { "*" },
          },
        },
      },
    },
    bashls = {
      cmd = { "bash-language-server", "start" },
      filetypes = { "sh", "bash" },
      root_markers = { ".git" },
    },
    terraformls = {
      cmd = { "terraform-ls", "serve" },
      filetypes = { "terraform", "tf", "terraform-vars" },
      root_markers = { ".terraform", ".git" },
    },
    yamlls = {
      cmd = { "yaml-language-server", "--stdio" },
      filetypes = { "yaml", "yml" },
      root_markers = { ".git" },
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

  -- mpls: on-demand markdown preview (not auto-enabled)
  vim.lsp.config("mpls", {
    cmd = { "mpls", "--theme", "dark", "--code-style", "catppuccin-frappe", "--enable-emoji", "--enable-footnotes" },
    filetypes = { "markdown" },
    root_markers = { ".marksman.toml", ".git" },
  })
  vim.keymap.set("n", "<leader>tp", function()
    local clients = vim.lsp.get_clients({ name = "mpls" })
    if #clients > 0 then
      vim.lsp.enable("mpls", false)
    else
      vim.lsp.enable("mpls")
    end
  end, { desc = "toggle preview" })

  -- LSP keymaps
  vim.keymap.set("n", "<leader>cf", function() require("conform").format({ lsp_fallback = true }) end, { desc = "format" })
  vim.keymap.set("n", "<leader>tf", function() Lsp.toggle() end, { desc = "format on save" })
  vim.keymap.set("n", "<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "inlay hints" })

  -- LspAttach: keymaps and native completion
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf
      if not client then return end

      -- Enable native completion
      if client.supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
      end

      -- Disable bashls formatting (shfmt via conform takes precedence)
      if client.name == "bashls" then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      vim.keymap.set("i", "<c-j>", "<c-n>", { buffer = bufnr, desc = "next completion" })
      vim.keymap.set("i", "<c-k>", "<c-p>", { buffer = bufnr, desc = "prev completion" })

      vim.keymap.set("n", "<leader>cF", function() require("conform").format({ lsp_fallback = true }) end, { buffer = bufnr, desc = "format (direct)" })
    end,
  })

  -- Setup LSP
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if vim.g.neovide then capabilities.textDocument.semanticTokens = vim.NIL end

  for server, opts in pairs(servers) do
    opts.capabilities = capabilities
    vim.lsp.config(server, opts)
  end
  vim.lsp.enable(vim.tbl_keys(servers))

  -- Format on save
  lsp.opts = {
    autoformat = true,
    format_notify = false,
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("Format", {}),
    callback = function(args)
      if lsp.opts.autoformat then
        require("conform").format({ bufnr = args.buf, lsp_fallback = true })
      end
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
