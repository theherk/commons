if not pcall(require, "luasnip") then return end

local ls = require("luasnip")
local types = require("luasnip.util.types")
require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config({
  enable_autosnippets = true,
  history = false,
  updateevents = "TextChanged,TextChangedI",
})

local s = ls.s
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local same = function(index)
  return f(function(args) return args[1] end, { index })
end

local date = function() return { os.date("%Y-%m-%d") } end

ls.add_snippets(nil, {
  all = {
    s({
      name = "date",
      trig = "date",
      dscr = "ISO-8601 short date",
    }, {
      f(date, {}),
    }),
  },
  markdown = {
    s({
      trig = "meta",
      name = "meta",
      dscr = "yaml frontmatter",
    }, {
      t({ "---", "title: " }),
      i(1, "title"),
      t({ "", "author: " }),
      i(2, "author"),
      t({ "", "date: " }),
      f(date, {}),
      t({ "", "tags: [" }),
      i(3, ""),
      t({ "]", "---", "" }),
      i(0),
    }),
  },
})

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-h>", function()
  if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true })

vim.keymap.set("i", "<c-j>", function()
  if ls.choice_active() then ls.change_choice(1) end
end)

vim.keymap.set("i", "<c-k>", function()
  if ls.choice_active() then ls.change_choice(1) end
end)

vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))

-- Reload luasnip.
vim.keymap.set("n", "<leader>L", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<cr>", { desc = "source luasnip" })