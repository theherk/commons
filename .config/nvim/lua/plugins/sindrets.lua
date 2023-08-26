return {
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
    -- Feels like this should be better.
    -- However, it breaks the whicheky register.
    -- keys = {
    --   { "Dd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
    --   { "Dc", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
    --   { "Df", "<cmd>DiffviewToggleFiles<cr>", desc = "DiffviewToggleFiles" },
    --   { "Dh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffviewFileHistory" },
    --   { "Dl", "<cmd>DiffviewLog<cr>", desc = "DiffviewLog" },
    --   { "Dr", "<cmd>DiffviewRefresh<cr>", desc = "DiffviewRefresh" },
    --   { "Dq", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
    -- },
  },
}
