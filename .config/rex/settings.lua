-- Settings the app keeps in its own preferences. Run once per machine from the
-- command palette ("Import Catppuccin Themes", then "Apply Settings"); both are
-- safe to run again.
local util = require("util")

local module = {}

local CATPPUCCIN = util.HOME .. "/projects/github.com/catppuccin/ghostty"

local SETTINGS = {
  { "client.setting.themes.dark.palette", { value = "Catppuccin Frappe" } },
  { "client.setting.themes.light.palette", { value = "Catppuccin Latte" } },
  { "client.setting.terminal.typography.font", { value = "VictorMono Nerd Font Mono" } },
  { "client.setting.terminal.typography.size", { value = 18 } },
  { "client.setting.terminal.selection.copy_on_select", { value = true } },
  { "client.setting.terminal.cursor.shaders", { value = true } },
  { "client.setting.terminal.cursor.shader", { value = "warp" } },
  { "client.setting.interface.active_panes.fade", { value = "both" } },
}

rex.action({
  name = "import_catppuccin",
  title = "Import Catppuccin Themes",
  description = "One-time: clone catppuccin/ghostty if missing and import Frappe and Latte.",
  run = function(ctx, args)
    if not util.run({ "test", "-d", CATPPUCCIN }).ok then
      local r = util.run({ "git", "clone", "--depth", "1", "https://github.com/catppuccin/ghostty.git", CATPPUCCIN })
      if not r.ok then error(r.stderr, 0) end
    end
    rex.client.queue("client.theme.import", { path = CATPPUCCIN .. "/themes/catppuccin-latte.conf" })
    rex.client.queue("client.theme.import", { path = CATPPUCCIN .. "/themes/catppuccin-frappe.conf" })
  end,
})

rex.action({
  name = "apply_settings",
  title = "Apply Settings",
  description = "Set the app settings kept in ~/commons/.config/rex/settings.lua.",
  run = function(ctx, args)
    for _, s in ipairs(SETTINGS) do rex.client.queue(s[1], s[2]) end
  end,
})

return module
