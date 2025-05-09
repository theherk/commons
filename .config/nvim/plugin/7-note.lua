local MiniDeps = require("mini.deps")
local add, later = MiniDeps.add, MiniDeps.later

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

later(function()
  add({
    source = "obsidian-nvim/obsidian.nvim",
    depend = {
      "echasnovski/mini.pick",
      "hrsh7th/nvim-cmp",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Required pngpaste on MacOS. `brew install pngpaste`
    },
  })
  require("obsidian").setup({
    daily_notes = {
      alias_format = "%Y-%m-%d",
      folder = "journal",
      default_tags = { "daily-notes" },
      template = "journal",
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
    templates = { folder = "templates" },
    ui = { enable = false },
    workspaces = workspaces(),
  })
  vim.keymap.set("n", "<leader>nb", "<cmd>ObsidianBacklinks<cr>", { desc = "obsidian backlinks" })
  vim.keymap.set("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", { desc = "obsidian find" })
  vim.keymap.set("n", "<leader>ni", "<cmd>ObsidianPasteImg<cr>", { desc = "obsidian img" })
  vim.keymap.set("n", "<leader>njm", "<cmd>ObsidianTomorrow<cr>", { desc = "obsidian tomorrow" })
  vim.keymap.set("n", "<leader>njt", "<cmd>ObsidianToday<cr>", { desc = "obsidian today" })
  vim.keymap.set("n", "<leader>njy", "<cmd>ObsidianYesterday<cr>", { desc = "obsidian yesterday" })
  vim.keymap.set("n", "<leader>nll", "<cmd>ObsidianLink<cr>", { desc = "obsidian link" })
  vim.keymap.set("n", "<leader>nln", "<cmd>ObsidianLinkNew<cr>", { desc = "obsidian link new" })
  vim.keymap.set("n", "<leader>nn", "<cmd>ObsidianNew<cr>", { desc = "obsidian new" })
  vim.keymap.set("n", "<leader>no", "<cmd>ObsidianOpen<cr>", { desc = "obsidian open" })
  vim.keymap.set("n", "<leader>nr", "<cmd>ObsidianRename<cr>", { desc = "obsidian rename" })
  vim.keymap.set("n", "<leader>ns", "<cmd>ObsidianSearch<cr>", { desc = "obsidian search" })
  vim.keymap.set("n", "<leader>nt", "<cmd>ObsidianTags<cr>", { desc = "obsidian tags" })
  vim.keymap.set("n", "<leader>nwb", "<cmd>ObsidianWorkspace brain<cr>", { desc = "select workspace brain" })
  vim.keymap.set("n", "<leader>nwd", "<cmd>ObsidianWorkspace dnbrain<cr>", { desc = "select workspace dnbrain" })
  vim.keymap.set("n", "<localleader>mx", require("obsidian.util").toggle_checkbox, { desc = "mark complete" })
end)
