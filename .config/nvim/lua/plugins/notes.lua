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
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      daily_notes = {
        alias_format = "%Y-%m-%d",
      },
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
