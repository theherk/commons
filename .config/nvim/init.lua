vim.loader.enable()

Config = {}

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
    if name == "markdown-preview" and vim.tbl_contains({ "install", "update" }, kind) then
      if not ev.data.active then vim.cmd.packadd("markdown-preview") end
      vim.fn["mkdp#util#install"]()
    end
  end,
})

vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

local misc = require("mini.misc")
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely("event:" .. ev, f) end
