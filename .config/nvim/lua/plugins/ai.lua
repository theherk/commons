return {
  {
    "Exafunction/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    commit = "937667b2",
    enabled = vim.fn.getcwd():find("dnb.no") == nil and vim.fn.filereadable(".codeium-enabled") == 1,
  },
  {
    "David-Kunz/gen.nvim",
    -- Requires:
    --   ollama serve
    --   ollama run llama3
    opts = { model = "llama3" },
  },
  {
    "yetone/avante.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "nvim-lua/plenary.nvim",
      {
        "grapp-dev/nui-components.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
      },
    },
    event = "VeryLazy",
    build = "make",
    opts = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        temperature = 0,
        max_tokens = 4096,
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = vim.fn.getcwd():find("dnb.no") ~= nil,
    config = true,
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = vim.fn.getcwd():find("dnb.no") ~= nil,
    opts = {
      auth_provider_url = "https://dnb.ghe.com",
      panel = { enabled = false },
      suggestion = { enabled = false },
    },
  },
}
