---@diagnostic disable-next-line: lowercase-global
version = "1.0.0"
local xplr = xplr
-- xplr.config.general.show_hidden = true

local home = os.getenv("HOME")
package.path = home .. "/.config/xplr/plugins/?/init.lua;" .. home .. "/.config/xplr/plugins/?.lua;" .. package.path
require("icons").setup()
require("zentable").setup()
require("zoxide").setup({
  bin = "zoxide",
  mode = "default",
  key = "z",
})

xplr.config.general.global_key_bindings = {
  on_key = {
    ["e"] = {
      help = "edit",
      messages = {
        {
          BashExec0 = [===[
            ${EDITOR:-vi} "${XPLR_FOCUS_PATH:?}"
          ]===],
        },
        "Quit",
      },
    },
    ["ctrl-e"] = {
      help = "edit",
      messages = {
        {
          BashExec0 = [===[
            ${EDITOR:-vi} "${XPLR_FOCUS_PATH:?}"
          ]===],
        },
        "PopMode",
      },
    },
  },
}
