return {
  {
    "2kabhishek/co-author.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "CoAuthor" },
    keys = { { "<leader>gC", "<cmd>CoAuthor<cr>", desc = "co-author" } },
  },
  {
    "emmanueltouzery/agitator.nvim",
    dependencies = {
      "NeogitOrg/neogit",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gB", function() require("agitator").git_blame_toggle() end, desc = "blame (full)" },
      { "<leader>gt", function() require("agitator").git_time_machine({ use_current_win = true }) end, desc = "time machine" },
    },
  },
  {
    "fredeeb/tardis.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = true,
    keys = {
      { "<leader>gT", "<cmd>Tardis<cr>", desc = "tardis" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    config = true,
    opts = {
      disable_insert_on_commit = false,
      git_services = {
        ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        ["gitlab.tech.dnb.no"] = "https://gitlab.tech.dnb.no/${path}/${repository}/-/merge_requests/new?merge_request[source_branch]=${branch_name}&merge_request[target_branch]=main",
      },
      graph_style = "unicode",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "neogit" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

        map("n", "]h", gs.next_hunk, "next hunk")
        map("n", "[h", gs.prev_hunk, "prev hunk")
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<cr>", "stage hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<cr>", "reset hunk")
        map("n", "<leader>gS", gs.stage_buffer, "stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "undo stage hunk")
        map("n", "<leader>gR", gs.reset_buffer, "reset buffer")
        map("n", "<leader>gp", gs.preview_hunk, "preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "blame line")
        map("n", "<leader>gf", gs.diffthis, "diff this file")
        map("n", "<leader>gF", function() gs.diffthis("~") end, "diff this ~")
        map({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", "select hunk")
      end,
    },
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("gitlinker").setup({
        callbacks = {
          ["gitlab.tech.dnb.no"] = require("gitlinker.hosts").get_gitlab_type_url,
        },
        mappings = nil,
      })
    end,
    keys = {
      { "<leader>glb", function() require("gitlinker").get_repo_url() end, mode = { "n", "v" }, desc = "base yank" },
      { "<leader>glB", function() require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").open_in_browser }) end, mode = { "n", "v" }, desc = "base open" },
      { "<leader>glr", function() require("gitlinker").get_buf_range_url("n") end, desc = "range yank" },
      { "<leader>glR", function() require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser }) end, desc = "range open" },
      { "<leader>glr", function() require("gitlinker").get_buf_range_url("v") end, mode = { "v" }, desc = "range yank" },
      { "<leader>glR", function() require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").open_in_browser }) end, mode = { "v" }, desc = "range open" },
    },
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
    keys = {
      { "<leader>gdd", "<cmd>DiffviewOpen<cr>", desc = "open diffview" },
      { "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "diffview history" },
      { "<leader>gdl", "<cmd>DiffviewLog<cr>", desc = "diffview log" },
      { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "diffview refresh" },
    },
    opts = {
      enhanced_diff_hl = true,
      keymaps = {
        view = {
          { "n", "q", "<cmd>set hidden<cr><cmd>DiffviewClose<cr><cmd>set nohidden<cr>", { desc = "close" } },
        },
        file_panel = {
          { "n", "q", "<cmd>set hidden<cr><cmd>DiffviewClose<cr><cmd>set nohidden<cr>", { desc = "close" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>set hidden<cr><cmd>DiffviewClose<cr><cmd>set nohidden<cr>", { desc = "close" } },
        },
      },
    },
  },
}
