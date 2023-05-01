lvim.format_on_save = {
  enabled = true,
  pattern = "*",
  timeout = 1000,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

-- -- linters, formatters and code actions <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "black",
    filetypes = { "python" }
  },
  {
    command = "prettier",
    extra_args = { "--print-width", "100" },
    filetypes = { "javascript", "typescript", "typescriptreact" },
  },
  {
    command = "beautysh",
    filetypes = { "bash", "sh", "zsh" },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
  },
  { command = "zsh",    filetypes = { "zsh" } },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    exe = "eslint",
    filetypes = { "javascript", "typescript", "typescriptreact" },
  },
}
