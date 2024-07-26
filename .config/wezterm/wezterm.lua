local control = require("control")
local theme = require("theme")
local util = require("util")
local wezterm = require("wezterm")

local config = {}

wezterm.on("format-tab-title", util.format_tab_title)

wezterm.on("update-right-status", util.update_right_status)

wezterm.on("user-var-changed", util.user_var_changed)

local paths = {
  "/opt/homebrew/bin",
  os.getenv("PATH"),
}

config = {
  check_for_updates = false,
  default_gui_startup_args = { "connect", "unix" },
  set_environment_variables = {
    LG_CONFIG_FILE = wezterm.home_dir .. "/.config/lazygit/config.yml",
    PATH = table.concat(paths, ":"),
  },
  unix_domains = { { name = "unix" } },
}

control.apply_to_config(config)
theme.apply_to_config(config)

return config
