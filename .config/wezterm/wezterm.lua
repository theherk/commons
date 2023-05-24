local control = require "control"
local theme = require "theme"
local util = require "util"
local wezterm = require "wezterm"

local config = {}

wezterm.on(
  "format-tab-title",
  util.format_tab_title
)

wezterm.on(
  "update-right-status",
  util.update_right_status
)

wezterm.on(
  "user-var-changed",
  util.user_var_changed
)

config = {
  check_for_updates = false,
}

control.apply_to_config(config)
theme.apply_to_config(config)

return config
