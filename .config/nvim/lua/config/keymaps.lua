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
    C = { name = "+Codeium" },
    D = { name = "+Diffview" },
    n = { name = "+Neorg" },
    o = { name = "+Open / Options" },
    t = { name = "+Trouble" },
  },
})

map("n", "<leader><leader>", "<cmd>Telescope git_files<cr>", { desc = "Git Files" })
map("n", "<leader>Dd", "<cmd>DiffviewOpen<cr>", { desc = "DiffviewOpen" })
map("n", "<leader>Dc", "<cmd>DiffviewClose<cr>", { desc = "DiffviewClose" })
map("n", "<leader>Df", "<cmd>DiffviewToggleFiles<cr>", { desc = "DiffviewToggleFiles" })
map("n", "<leader>Dh", "<cmd>DiffviewFileHistory<cr>", { desc = "DiffviewFileHistory" })
map("n", "<leader>Dl", "<cmd>DiffviewLog<cr>", { desc = "DiffviewLog" })
map("n", "<leader>Dr", "<cmd>DiffviewRefresh<cr>", { desc = "DiffviewRefresh" })
map("n", "<leader>Dq", "<cmd>DiffviewClose<cr>", { desc = "DiffviewClose" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
map("n", "<leader>J", "<cmd>TSJToggle<cr>", { desc = "Treesj" })
map("n", "<leader>m", "<cmd>TSJToggle<cr>", { desc = "Treesj" })
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
map("n", "<leader>of", "<cmd>Fzf<cr>", { desc = "Fzf" })
map("n", "<leader>os", "<cmd>Skim<cr>", { desc = "Skim" })
map("n", "<leader>ow", "<cmd>:set wrap!<cr>", { desc = "Wrap" })
map("n", "<leader>ox", "<cmd>Xplr<cr>", { desc = "Xplr" })
map("n", "<leader>P", "<cmd>Telescope projects<cr>", { desc = "Projects" })
map("n", "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Current Buf Fuzzy" })
map("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { desc = "Trouble" })
map("n", "<leader>Z", "<cmd>ZenMode<cr>", { desc = "Zen" })

map("n", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign" })
map("v", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign" })

local agitator = require("agitator")
-- stylua: ignore
map("n", "<leader>gb", function() return agitator.git_blame_toggle() end, { desc = "Blame (agitator)" })
-- stylua: ignore
map("n", "<leader>gt", function() return agitator.git_time_machine() end, { desc = "Time Machine (agitator)" })

-- Overwriting defaults to get border on terms.
local Util = require("lazyvim.util")
map("n", "<leader>gG", function()
  Util.float_term({ "lazygit" }, { border = "single", cwd = Util.get_root(), esc_esc = false, ctrl_hjkl = false })
end, { desc = "Lazygit" })
local lazyterm = function()
  Util.float_term(nil, { border = "single", cwd = Util.get_root() })
end
map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<leader>fT", function()
  Util.float_term()
end, { desc = "Terminal (cwd)" })
map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })
