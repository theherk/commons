-- Run from an obsidian vault with:
-- :luafile ~/bin/fix-frontmatter.lua
local client = require("obsidian").get_client()

client:apply_async(function(note)
  print(string.format("Updating note %s...", note.path))
  note:save()
end)
