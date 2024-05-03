vim.cmd([[autocmd BufRead,BufNewFile *.hcl,*.tfbackend set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "hcl", "terraform" },
  desc = "terraform/hcl commentstring configuration",
  command = "setlocal commentstring=#\\ %s",
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
      if type(opts.sources) == "table" then
        local null_ls = require("null-ls")
        vim.list_extend(opts.sources, {
          null_ls.builtins.formatting.hclfmt,
          null_ls.builtins.formatting.terraform_fmt,
          null_ls.builtins.diagnostics.terraform_validate,
        })
      end
    end,
  },
}
