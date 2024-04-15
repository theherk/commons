return {
  {
    "Exafunction/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    enabled = vim.fn.getcwd():find("dnb.no") == nil and vim.fn.filereadable(".codeium-enabled") == 1,
  },
}
