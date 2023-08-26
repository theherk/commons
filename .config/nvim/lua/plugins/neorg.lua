return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    config = function()
      require("neorg").setup({
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
              workspace = os.getenv("NEORG_DEFAULT_WORKSPACE") or "main",
            },
          },
          ["core.keybinds"] = {
            config = {
              hook = function(keybinds)
                keybinds.remap_event("norg", "i", "<C-CR>", "core.itero.next-iteration")
                keybinds.remap_event("norg", "n", "<C-CR>", "core.itero.next-iteration")
              end,
            },
          },
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode",
            },
          },
          ["core.summary"] = {},
        },
      })
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
    },
  },
}
