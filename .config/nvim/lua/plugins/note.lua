local onedrive = os.getenv("ONEDRIVE") or "/Users/h4s/Library/CloudStorage/OneDrive"

return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              main = "~/org/neorg",
              icloud = "~/Library/Mobile Documents/com~apple~CloudDocs/neorg",
              onedrive = onedrive .. "/neorg",
            },
            default_workspace = os.getenv("NEORG_DEFAULT_WORKSPACE") or "main",
          },
        },
        ["core.export"] = {
          config = {
            export_dir = "~/org/export/<language>",
          },
        },
        ["core.export.markdown"] = {},
        ["core.integrations.telescope"] = {},
        ["core.journal"] = {
          config = {
            strategy = "flat",
            use_template = false,
            workspace = os.getenv("NEORG_DEFAULT_WORKSPACE") or "main",
          },
        },
        ["core.keybinds"] = {
          config = {
            hook = function(keys)
              vim.keymap.set("n", "<localleader>id", "<cmd>Neorg keybind norg core.tempus.insert-date<cr>", { desc = "insert date" })
              vim.keymap.set("n", "<localleader>lt", "<cmd>Neorg keybind norg core.pivot.toggle-list-type<cr>", { desc = "toggle list" })
              vim.keymap.set("n", "<localleader>mh", "<cmd>Neorg mode traverse-heading<cr>", { desc = "traverse headings" })
              vim.keymap.set("n", "<localleader>mn", "<cmd>Neorg mode norg<cr>", { desc = "norg mode" })
              vim.keymap.set("n", "<localleader>nn", "<cmd>Neorg keybind norg core.dirman.new.note<cr>", { desc = "new note" })
              vim.keymap.set("n", "<localleader>ta", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_ambiguous<cr>", { desc = "ambiguous" })
              vim.keymap.set("n", "<localleader>tc", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cancelled<cr>", { desc = "cancelled" })
              vim.keymap.set("n", "<localleader>td", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_done<cr>", { desc = "done" })
              vim.keymap.set("n", "<localleader>th", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_hold<cr>", { desc = "hold" })
              vim.keymap.set("n", "<localleader>ti", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_important<cr>", { desc = "important" })
              vim.keymap.set("n", "<localleader>tp", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_pending<cr>", { desc = "pending" })
              vim.keymap.set("n", "<localleader>tr", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_recurring<cr>", { desc = "recurring" })
              vim.keymap.set("n", "<localleader>tu", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_undone<cr>", { desc = "undone" })
              vim.keymap.set("n", "<localleader>uc", "<cmd>Neorg toggle-concealer<cr>", { desc = "toggle concealer" })
              keys.remap_event("norg", "i", "<c-cr>", "core.itero.next-iteration")
              keys.remap_event("norg", "n", "<c-cr>", "core.itero.next-iteration")
            end,
          },
        },
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },
        ["core.summary"] = {},
        -- ["core.tempus"] = {}, -- requires 0.10.0+
        ["external.templates"] = {},
      },
    },
    keys = {
      { "<leader>Ne", "<cmd>Neorg export to-file <cr>", desc = "export" },
      { "<leader>Nf", "<cmd>Telescope neorg find_norg_files<cr>", desc = "find" },
      { "<leader>Nh", "<cmd>Telescope neorg search_headings<cr>", desc = "headings" },
      { "<leader>Ni", "<cmd>Neorg index<cr>", desc = "index" },
      { "<leader>Nl", "<cmd>Telescope neorg insert_link<cr>", desc = "link" },
      { "<leader>NL", "<cmd>Telescope neorg insert_file_link<cr>", desc = "file link" },
      { "<leader>Nm", "<cmd>Neorg inject-metadata<cr>", desc = "meta" },
      { "<leader>Nr", "<cmd>Neorg return<cr>", desc = "return" },
      { "<leader>Nw", "<cmd>Telescope neorg switch_workspace<cr>", desc = "workspace" },
      { "<leader>Njm", "<cmd>Neorg journal tomorrow<cr>", desc = "tomorrow" },
      { "<leader>Njm", "<cmd>Neorg journal today<cr>", desc = "today" },
      { "<leader>Njm", "<cmd>Neorg journal yesterday<cr>", desc = "yesterday" },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Required pastepng on MacOS. `brew install pastepng`
    },
    keys = {
      { "<leader>nb", "<cmd>ObsidianBacklinks<cr>", desc = "backlinks" },
      { "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", desc = "find" },
      { "<leader>ni", "<cmd>ObsidianPasteImg<cr>", desc = "img" },
      { "<leader>njm", "<cmd>ObsidianTomorrow<cr>", desc = "tomorrow" },
      { "<leader>njt", "<cmd>ObsidianToday<cr>", desc = "today" },
      { "<leader>njy", "<cmd>ObsidianYesterday<cr>", desc = "yesterday" },
      { "<leader>nll", "<cmd>ObsidianLink<cr>", desc = "link" },
      { "<leader>nln", "<cmd>ObsidianLinkNew<cr>", desc = "new" },
      { "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "new" },
      { "<leader>nr", "<cmd>ObsidianRename<cr>", desc = "rename" },
      { "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "search" },
      { "<leader>nwm", "<cmd>ObsidianWorkspace main<cr>", desc = "main" },
      { "<leader>nwo", "<cmd>ObsidianWorkspace onedrive<cr>", desc = "onedrive" },
    },
    opts = {
      daily_notes = {
        alias_format = "%Y-%m-%d",
      },
      follow_url_func = function(url) vim.fn.jobstart({ "open", url }) end,
      note_id_func = function(title)
        -- Given "Note Name" will make ID `<timestamp>-note-name`.
        -- Filename is the same with `.md` suffix.
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      workspaces = {
        {
          name = "main",
          path = "~/org/foam",
        },
        {
          name = "onedrive",
          path = onedrive .. "/foam-onedrive",
        },
      },
    },
  },
}
