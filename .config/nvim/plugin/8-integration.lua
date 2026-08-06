local add = vim.pack.add
local later = Config.later

local ai_enabled = vim.env.AI_ENABLED == "1"

later(function()
  add({ "https://github.com/akinsho/toggleterm.nvim" })
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
      "https://github.com/nvim-lua/plenary.nvim",
      "https://github.com/olimorris/codecompanion.nvim",
    })
    local config = {
      adapters = {
        copilot = false,
        http = {
          omlx = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "omlx",
              env = {
                url = "http://localhost:8000",
                api_key = "OMLX_API_KEY",
              },
              schema = {
                model = {
                  default = "mlx-community--gemma-4-26b-a4b-it-4bit",
                },
              },
            })
          end,
        },
        acp = {
          raicode = function()
            return require("codecompanion.adapters").extend("claude_code", {
              commands = {
                default = {
                  "raicode-wrapper.sh",
                },
              },
            })
          end,
          goose = function()
            return require("codecompanion.adapters").extend("goose", {
              env = {
                -- Self-contained: force RAI Gateway explicitly rather than depending on
                -- config.yaml's active_provider (CLI state) or inherited shell env, which
                -- caused it to fall through to whatever github_copilot was last left as,
                -- then fail ("failed to get api info after 3 attempts") independent of
                -- ambient GITHUB_COPILOT_HOST. RAI Gateway is the already-proven-reliable
                -- provider; no reason this integration should depend on GHE Copilot state.
                RAICODE_GOOSE_TOKEN = "cmd:cat ~/.config/goose/secrets/rai-token",
                GOOSE_PROVIDER = "raicode",
                GOOSE_MODEL = "claude-sonnet-4-6",
                -- goose ignores per-model max_tokens in custom_providers/*.json (see
                -- ~/.local-exports for the same clamp on the CLI side); without this the
                -- request 400s the moment it exceeds sonnet-4-6's real 34000 output cap.
                GOOSE_MAX_TOKENS = "32000",
              },
            })
          end,
        },
      },
      display = {
        chat = {
          window = {
            -- Default (vertical/right split) has no winfixwidth/winfixheight protection
            -- from codecompanion itself, unlike neo-tree's own sidebar. Combined with
            -- Neovim's default equalalways=true, any window opening/closing anywhere
            -- reflows the chat's split unpredictably. `tab` sidesteps the split-equalize
            -- system entirely (separate tab-local window tree) instead of patching
            -- around it -- also gives a full-window feel, switch back with gt/gT.
            layout = "tab",
          },
        },
      },
    }
    require("codecompanion").setup(config)
    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle adapter=raicode<cr>", { desc = "codecompanion (toggle)" })
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "codecompanion" })
    vim.keymap.set({ "n", "v" }, "<leader>ao", "<cmd>CodeCompanionChat adapter=omlx<cr>", { desc = "codecompanion omlx" })
    vim.keymap.set({ "n", "v" }, "<leader>ar", "<cmd>CodeCompanionChat Toggle adapter=raicode<cr>", { desc = "codecompanion raicode" })
    vim.keymap.set({ "n", "v" }, "<leader>ag", "<cmd>CodeCompanionChat Toggle adapter=goose<cr>", { desc = "codecompanion goose" })
    vim.keymap.set({ "i", "x", "n", "s", "t" }, "<d-?>", "<cmd>CodeCompanionChat<cr>", { desc = "codecompanion" })
    vim.keymap.set({ "i", "x", "n", "s", "t" }, "<d-r>", "<cmd>CodeCompanionChat Toggle adapter=raicode<cr>", { desc = "codecompanion (toggle)" })
    vim.keymap.set({ "i", "x", "n", "s", "t" }, "<d-g>", "<cmd>CodeCompanionChat Toggle adapter=goose<cr>", { desc = "codecompanion goose (toggle)" })
  end)
end
