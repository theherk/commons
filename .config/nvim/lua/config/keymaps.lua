local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    C = { name = "Codeium" },
    D = { name = "Diffview" },
    n = { name = "Neorg" },
    o = { name = "Open / Options" },
    t = { name = "Trouble" },
  },
})

map("n", "<leader>Ce", "<cmd>let codeium_enabled = v:true<cr>", { desc = "Codeium Enable" })
map("n", "<leader>Cd", "<cmd>let codeium_enabled = v:false<cr>", { desc = "Codeium Disable" })
map("n", "<leader>Dd", "<cmd>DiffviewOpen<cr>", { desc = "DiffviewOpen" })
map("n", "<leader>Dc", "<cmd>DiffviewClose<cr>", { desc = "DiffviewClose" })
map("n", "<leader>Df", "<cmd>DiffviewToggleFiles<cr>", { desc = "DiffviewToggleFiles" })
map("n", "<leader>Dh", "<cmd>DiffviewFileHistory<cr>", { desc = "DiffviewFileHistory" })
map("n", "<leader>Dl", "<cmd>DiffviewLog<cr>", { desc = "DiffviewLog" })
map("n", "<leader>Dr", "<cmd>DiffviewRefresh<cr>", { desc = "DiffviewRefresh" })
map("n", "<leader>Dq", "<cmd>DiffviewClose<cr>", { desc = "DiffviewClose" })
map("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "Git Files" })
map("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>J", "<cmd>TSJToggle<CR>", { desc = "Treesj" })
map("n", "<leader>m", "<cmd>TSJToggle<CR>", { desc = "Treesj" })
map("n", "<leader>ne", "<cmd>Neorg export to-file <cr>", { desc = "Export" })
map("n", "<leader>nf", "<cmd>Telescope neorg find_norg_files<cr>", { desc = "Find" })
map("n", "<leader>nl", "<cmd>Telescope neorg insert_link<cr>", { desc = "Insert Link" })
map("n", "<leader>nm", "<cmd>Neorg inject-metadata<cr>", { desc = "Inject Metadata" })
map("n", "<leader>nL", "<cmd>Telescope neorg insert_file_link<cr>", { desc = "Insert File Link" })
map("n", "<leader>nr", "<cmd>Neorg return<cr>", { desc = "Return" })
map("n", "<leader>nw", "<cmd>Telescope neorg switch_workspace<cr>", { desc = "Workspace" })
map("n", "<leader>njm", "<cmd>Neorg journal tomorrow<cr>", { desc = "Tomorrow" })
map("n", "<leader>njt", "<cmd>Neorg journal today<cr>", { desc = "Today" })
map("n", "<leader>njy", "<cmd>Neorg journal yesterday<cr>", { desc = "Yesterday" })
map("n", "<leader>of", "<cmd>Fzf<CR>", { desc = "Fzf" })
map("n", "<leader>os", "<cmd>Skim<CR>", { desc = "Skim" })
map("n", "<leader>ow", "<cmd>:set wrap!<cr>", { desc = "Wrap" })
map("n", "<leader>ox", "<cmd>Xplr<CR>", { desc = "Xplr" })
map("n", "<leader>P", "<cmd>Telescope projects<CR>", { desc = "Projects" })
map("n", "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Current Buf Fuzzy" })
map("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { desc = "Trouble" })
map("n", "<leader>Z", "<cmd>ZenMode<CR>", { desc = "Zen" })

map("n", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign" })
map("v", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign" })
