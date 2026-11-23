-- Settings the app keeps in its own preferences. Run once per machine from the
-- command palette ("Import Catppuccin Themes", then "Apply Settings"); both are
-- safe to run again.
local util = require("util")

local module = {}

local CATPPUCCIN = util.HOME .. "/projects/github.com/catppuccin/ghostty"
local THEMES = util.HOME .. "/.cache/rex/themes"

-- Ghostty set cursor-color = #85c1dc (Frappe sapphire) over both themes.
local CURSOR = "85c1dc"
local DARK = "Catppuccin Frappe Sapphire"
local LIGHT = "Catppuccin Latte Sapphire"

local SETTINGS = {
  { "client.setting.themes.dark.palette", { value = DARK } },
  { "client.setting.themes.light.palette", { value = LIGHT } },
  { "client.setting.terminal.typography.font", { value = "VictorMono Nerd Font Propo" } },
  { "client.setting.terminal.typography.size", { value = 18 } },
  { "client.setting.terminal.selection.copy_on_select", { value = true } },
  { "client.setting.terminal.cursor.shaders", { value = true } },
  { "client.setting.terminal.cursor.shader", { value = "warp" } },
  { "client.setting.interface.active_panes.fade", { value = "both" } },
}

-- Copy a catppuccin theme with the cursor color replaced. Rex names an
-- imported theme after its file, so the copy is written without an extension.
local function derive(file, name)
  local src = assert(io.open(CATPPUCCIN .. "/themes/" .. file, "r"))
  local text = src:read("*a")
  src:close()
  text = text:gsub("\ncursor%-color%s*=[^\n]*", "\ncursor-color = " .. CURSOR)
  local path = THEMES .. "/" .. name
  local dst = assert(io.open(path, "w"))
  dst:write(text)
  dst:close()
  return path
end

rex.action({
  name = "import_catppuccin",
  title = "Import Catppuccin Themes",
  description = "One-time: clone catppuccin/ghostty if missing and import Frappe and Latte with the Ghostty cursor color.",
  run = function(ctx, args)
    if not util.run({ "test", "-d", CATPPUCCIN }).ok then
      local r = util.run({ "git", "clone", "--depth", "1", "https://github.com/catppuccin/ghostty.git", CATPPUCCIN })
      if not r.ok then error(r.stderr, 0) end
    end
    util.run({ "mkdir", "-p", THEMES })
    rex.client.queue("client.theme.import", { path = derive("catppuccin-latte.conf", LIGHT) })
    rex.client.queue("client.theme.import", { path = derive("catppuccin-frappe.conf", DARK) })
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
