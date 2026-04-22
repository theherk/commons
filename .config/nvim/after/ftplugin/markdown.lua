vim.opt.wrap = true

vim.keymap.set("i", "<c-l>", function()
  if not Obsidian then return end
  Obsidian.picker.find_notes({
    prompt_title = "Insert link",
    no_default_mappings = true,
    callback = function(path)
      local note = require("obsidian.note").from_file(path)
      vim.api.nvim_put({ note:format_link() }, "", false, true)
    end,
  })
end, { buffer = 0, desc = "obsidian insert link" })
