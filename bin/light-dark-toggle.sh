#!/usr/bin/env sh

cd ~/commons || return
if grep -q "light = true" ~/.config/git/config; then
  sed -i '' 's/\(--theme=\)".*"/\1"OneHalfDark"/' .config/bat/config
  sed -i '' 's/\(.*light =\).*/\1 false/' .config/git/config
  sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1h4s-tokyo-night)/' .config/doom/config.org
  sed -i '' 's/\(local selected_scheme = \)".*"/\1"tokyonight"/' .config/wezterm/wezterm.lua
  sed -i '' 's/\(lvim.colorscheme = \)".*"/\1"tokyonight-night"/' .config/lvim/lua/user/display.lua
  sed -i '' 's/\(lvim.transparent_window = \).*/\1true/' .config/lvim/lua/user/display.lua
  sed -i '' 's/\(command_fg: \).*,/\1Gray,/' .config/gitui/theme.ron
  sed -i '' 's/\(selection_bg: \).*,/\1Rgb(11,41,66),/' .config/gitui/theme.ron
  sed -i '' 's/\(cmdbar_extra_lines_bg: \).*,/\1Rgb(11,41,66),/' .config/gitui/theme.ron
else
  sed -i '' 's/\(--theme=\)".*"/\1"OneHalfLight"/' .config/bat/config
  sed -i '' 's/\(.*light =\).*/\1 true/' .config/git/config
  sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1doom-one-light)/' .config/doom/config.org
  sed -i '' 's/\(local selected_scheme = \)".*"/\1"tokyonight-day"/' .config/wezterm/wezterm.lua
  sed -i '' 's/\(lvim.colorscheme = \)".*"/\1"tokyonight-day"/' .config/lvim/lua/user/display.lua
  sed -i '' 's/\(lvim.transparent_window = \).*/\1false/' .config/lvim/lua/user/display.lua
  sed -i '' 's/\(command_fg: \).*,/\1White,/' .config/gitui/theme.ron
  sed -i '' 's/\(selection_bg: \).*,/\1LightBlue,/' .config/gitui/theme.ron
  sed -i '' 's/\(cmdbar_extra_lines_bg: \).*,/\1LightBlue,/' .config/gitui/theme.ron
fi
