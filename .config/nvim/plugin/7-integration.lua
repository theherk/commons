local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add({source = "akinsho/toggleterm.nvim"})
  require("toggleterm").setup({
    shade_terminals = false,
    size = function(term)
      if term.direction == "horizontal" then
        return 22
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
  })
  vim.keymap.set({"i", "x", "n", "s", "t"}, "<c-`>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "terminal (horizontal)" } )
  vim.keymap.set({"i", "x", "n", "s", "t"}, "<d-j>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "terminal (horizontal)" } )
  vim.keymap.set({"i", "x", "n", "s", "t"}, "<ds-j>", "<cmd>ToggleTerm direction=tab<cr>", { desc = "terminal (tab)" } )
end)
