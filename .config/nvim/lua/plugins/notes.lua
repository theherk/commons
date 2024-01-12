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
              onedrive = os.getenv("NEORG_ONEDRIVE") or "~/Library/CloudStorage/OneDrive/neorg",
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
              local wk = require("which-key")
              wk.register({
                ["<localleader>"] = {
                  i = {
                    name = "+insert",
                    d = { "<cmd>Neorg keybind norg core.tempus.insert-date<cr>", "date" },
                  },
                  l = {
                    name = "+list",
                    i = { "<cmd>Neorg keybind norg core.pivot.invert-list-type<cr>", "invert" },
                    t = { "<cmd>Neorg keybind norg core.pivot.toggle-list-type<cr>", "toggle" },
                  },
                  m = {
                    name = "+mode",
                    h = { "<cmd>Neorg mode traverse-heading<cr>", "traverse" },
                    n = { "<cmd>Neorg mode norg<cr>", "norg" },
                  },
                  n = {
                    name = "+note",
                    n = { "<cmd>Neorg keybind norg core.dirman.new.note<cr>", "new" },
                  },
                  t = {
                    name = "+mark",
                    a = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_ambiguous<cr>", "ambiguous" },
                    c = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cancelled<cr>", "cancelled" },
                    d = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_done<cr>", "done" },
                    h = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_on_hold<cr>", "hold" },
                    i = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_important<cr>", "important" },
                    p = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_pending<cr>", "pending" },
                    r = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_recurring<cr>", "recurring" },
                    u = { "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_undone<cr>", "undone" },
                  },
                  u = {
                    name = "+toggle",
                    c = { "<cmd>Neorg toggle-concealer<cr>", "concealer" },
                  },
                },
              })
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
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "main",
          path = "~/org/foam",
        },
        {
          name = "onedrive",
          path = os.getenv("FOAM_ONEDRIVE") or "~/Library/CloudStorage/OneDrive/foam",
        },
      },
    },
    detect_cwd = true,
  },
}
