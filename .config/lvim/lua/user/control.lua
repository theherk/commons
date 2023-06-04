local actions = require("telescope.actions")

vim.g.maplocalleader = ","

lvim.builtin.which_key.mappings["J"] = { "<cmd>TSJToggle<CR>", "Treesj Toggle" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["ss"] = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Current Buf Fuzzy" }
lvim.builtin.which_key.mappings["/"] = { "<cmd>Telescope live_grep<CR>", "Grep" }
lvim.builtin.telescope.defaults.mappings.i = {
  ["<esc>"] = actions.close,
}
lvim.builtin.telescope.defaults.path_display = { "truncate" }

lvim.builtin.which_key.mappings["o"] = {
  name = "Options",
  w = { "<cmd>:set wrap!<cr>", "Wrap" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Trouble (diag)",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.keys.normal_mode["[b"] = ":bprev<CR>"
lvim.keys.normal_mode["]b"] = ":bnext<CR>"
