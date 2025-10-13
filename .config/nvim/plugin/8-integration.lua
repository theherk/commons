local MiniDeps = require("mini.deps")
local add, later = MiniDeps.add, MiniDeps.later

local ai_enabled = vim.env.AI_ENABLED == "1"

later(function()
  add({ source = "akinsho/toggleterm.nvim" })
  require("toggleterm").setup({
    shade_terminals = false,
    size = function(term)
      if term.direction == "horizontal" then
        return 22
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
  })
  vim.keymap.set({ "i", "x", "n", "s", "t" }, "<c-`>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "terminal (horizontal)" })
  vim.keymap.set({ "i", "x", "n", "s", "t" }, "<d-j>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "terminal (horizontal)" })
  vim.keymap.set({ "i", "x", "n", "s", "t" }, "<ds-j>", "<cmd>ToggleTerm direction=tab<cr>", { desc = "terminal (tab)" })
  local terminal = require("toggleterm.terminal").Terminal
  local jjui = terminal:new({
    cmd = "jjui",
    dir = "git_dir",
    direction = "tab",
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
    end,
    on_close = function() vim.cmd("startinsert!") end,
  })
  local lazygit = terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "tab",
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
    end,
    on_close = function() vim.cmd("startinsert!") end,
  })
  function _Jjui_toggle() jjui:toggle() end

  function _Lazygit_toggle() lazygit:toggle() end

  vim.keymap.set({ "n" }, "<leader>u", "<cmd>lua _Jjui_toggle()<cr>", { desc = "jjui" })
  vim.keymap.set({ "n" }, "<leader>gg", "<cmd>lua _Lazygit_toggle()<cr>", { desc = "lazygit" })
end)

if ai_enabled then
  later(function()
    add({
      source = "olimorris/codecompanion.nvim",
      depends = {
        "nvim-lua/plenary.nvim",
      },
    })
    local config = {
      adapters = {
        copilot = false,
        acp = {
          raicode = function()
            return require("codecompanion.adapters").extend("claude_code", {
              name = "raicode",
              commands = {
                default = {
                  "raicode-wrapper.sh",
                },
              },
            })
          end,
        },
      },
    }
    require("codecompanion").setup(config)
    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle adapter=raicode<cr>", { desc = "codecompanion (toggle)" })
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "codecompanion" })
    vim.keymap.set({ "n", "v" }, "<leader>ao", "<cmd>CodeCompanionChat ollama<cr>", { desc = "codecompanion ollama" })
    vim.keymap.set({ "n", "v" }, "<leader>ar", "<cmd>CodeCompanionChat raicode<cr>", { desc = "codecompanion raicode" })
    vim.keymap.set({ "i", "x", "n", "s", "t" }, "<d-?>", "<cmd>CodeCompanionChat<cr>", { desc = "codecompanion" })
    vim.keymap.set({ "i", "x", "n", "s", "t" }, "<d-r>", "<cmd>CodeCompanionChat Toggle adapter=raicode<cr>", { desc = "codecompanion (toggle)" })
  end)
end
