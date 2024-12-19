local onedrive = os.getenv("ONEDRIVE") or "/Users/h4s/Library/CloudStorage/OneDrive"
local function workspaces()
  local _workspaces = { {
    name = "brain",
    path = "~/vaults/brain",
  } }
  if vim.fn.isdirectory(onedrive) ~= 0 then table.insert(_workspaces, {
    name = "dnbrain",
    path = onedrive .. "/dnbrain",
  }) end
  return _workspaces
end

return {
  {
    "nvim-neorg/neorg",
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
      { "<leader>Ne", "<cmd>Neorg export to-file <cr>", desc = "neorg export" },
      { "<leader>Nf", "<cmd>Telescope neorg find_norg_files<cr>", desc = "find norg files" },
      { "<leader>Nh", "<cmd>Telescope neorg search_headings<cr>", desc = "search headings" },
      { "<leader>Ni", "<cmd>Neorg index<cr>", desc = "open index" },
      { "<leader>Nl", "<cmd>Telescope neorg insert_link<cr>", desc = "insert link" },
      { "<leader>NL", "<cmd>Telescope neorg insert_file_link<cr>", desc = "file link" },
      { "<leader>Nm", "<cmd>Neorg inject-metadata<cr>", desc = "inject meta" },
      { "<leader>Nr", "<cmd>Neorg return<cr>", desc = "neorg return" },
      { "<leader>Nw", "<cmd>Telescope neorg switch_workspace<cr>", desc = "select workspace" },
      { "<leader>Njm", "<cmd>Neorg journal tomorrow<cr>", desc = "neorg tomorrow" },
      { "<leader>Njm", "<cmd>Neorg journal today<cr>", desc = "neorg today" },
      { "<leader>Njm", "<cmd>Neorg journal yesterday<cr>", desc = "neorg yesterday" },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Required pngpaste on MacOS. `brew install pngpaste`
    },
    ft = { "markdown" },
    keys = {
      { "<leader>nb", "<cmd>ObsidianBacklinks<cr>", desc = "obsidian backlinks" },
      { "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", desc = "obsidian find" },
      { "<leader>ni", "<cmd>ObsidianPasteImg<cr>", desc = "obsidian img" },
      { "<leader>njm", "<cmd>ObsidianTomorrow<cr>", desc = "obsidian tomorrow" },
      { "<leader>njt", "<cmd>ObsidianToday<cr>", desc = "obsidian today" },
      { "<leader>njy", "<cmd>ObsidianYesterday<cr>", desc = "obsidian yesterday" },
      { "<leader>nll", "<cmd>ObsidianLink<cr>", desc = "obsidian link" },
      { "<leader>nln", "<cmd>ObsidianLinkNew<cr>", desc = "obsidian link new" },
      { "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "obsidian new" },
      { "<leader>no", "<cmd>ObsidianOpen<cr>", desc = "obsidian open" },
      { "<leader>nr", "<cmd>ObsidianRename<cr>", desc = "obsidian rename" },
      { "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "obsidian search" },
      { "<leader>nt", "<cmd>ObsidianTags<cr>", desc = "obsidian tags" },
      { "<leader>nwm", "<cmd>ObsidianWorkspace brain<cr>", desc = "select workspace brain" },
      { "<leader>nwo", "<cmd>ObsidianWorkspace dnbrain<cr>", desc = "select workspace dnbrain" },
      { "<localleader>mx", function() require("obsidian.util").toggle_checkbox() end, desc = "mark complete" },
    },
    opts = {
      daily_notes = {
        alias_format = "%Y-%m-%d",
        folder = "journal",
      },
      disable_frontmatter = true,
      follow_url_func = function(url) vim.fn.jobstart({ "open", url }) end,
      note_frontmatter_func = function(note)
        local out = { tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      note_id_func = function(title)
        if title ~= nil then
          return title
        else
          local suffix = ""
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      end,
      open_app_foreground = true,
      preferred_link_style = "markdown",
      ui = { enable = false },
      workspaces = workspaces(),
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
    },
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    opts = {
      mappings = {
        go_curr_heading = "[c",
        go_parent_heading = "[p",
      },
      on_attach = function(bufnr)
        vim.keymap.set({ "n", "i" }, "<m-o>", "<cmd>MDListItemBelow<cr>", { buffer = bufnr, desc = "item below" })
        vim.keymap.set({ "n", "i" }, "<m-O>", "<cmd>MDListItemAbove<cr>", { buffer = bufnr, desc = "item above" })
      end,
    },
  },
}
