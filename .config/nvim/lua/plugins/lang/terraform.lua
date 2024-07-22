local null_ls = require("null-ls")
local h = require("null-ls.helpers")
local u = require("null-ls.utils")

vim.cmd([[autocmd BufRead,BufNewFile *.hcl,*.tfbackend set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "hcl", "terraform" },
  desc = "terraform/hcl commentstring configuration",
  command = "setlocal commentstring=#\\ %s",
})

local terraform_validate = null_ls.builtins.diagnostics.terraform_validate.with({
  -- This is an updated function, to allow me to filter some unwanted messages.
  on_output = function(params)
    local combined_diagnostics = {}

    -- keep diagnostics from other directories
    if params.source_id ~= nil then
      local namespace = require("null-ls.diagnostics").get_namespace(params.source_id)
      local old_diagnostics = vim.diagnostic.get(nil, { namespace = namespace })
      for _, old_diagnostic in ipairs(old_diagnostics) do
        if not vim.startswith(old_diagnostic.filename, params.cwd) then table.insert(combined_diagnostics, old_diagnostic) end
      end
    end

    for _, new_diagnostic in ipairs(params.output.diagnostics) do
      local message = new_diagnostic.summary
      if new_diagnostic.detail then message = message .. " - " .. new_diagnostic.detail end
      local rewritten_diagnostic = {
        message = message,
        row = 0,
        col = 0,
        source = "terraform validate",
        severity = h.diagnostics.severities[new_diagnostic.severity],
        filename = params.bufname,
      }
      if new_diagnostic.range ~= nil then
        rewritten_diagnostic.col = new_diagnostic.range.start.column
        rewritten_diagnostic.end_col = new_diagnostic.range["end"].column
        rewritten_diagnostic.row = new_diagnostic.range.start.line
        rewritten_diagnostic.end_row = new_diagnostic.range["end"].line
        rewritten_diagnostic.filename = u.path.join(params.cwd, new_diagnostic.range.filename)
      end

      if new_diagnostic.detail:match("module is not yet installed") then goto continue end
      table.insert(combined_diagnostics, rewritten_diagnostic)
      ::continue::
    end
    return combined_diagnostics
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then vim.list_extend(opts.ensure_installed, {
        "terraform",
        "hcl",
      }) end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      vim.lsp.set_log_level("debug")
      if type(opts.sources) == "table" then
        vim.list_extend(opts.sources, {
          null_ls.builtins.formatting.hclfmt,
          null_ls.builtins.formatting.terraform_fmt,
          -- null_ls.builtins.diagnostics.terraform_validate,
          terraform_validate,
        })
      end
    end,
  },
}
