#!/usr/bin/env sh

# items to control:
# - bat
# - codium
# - doom
# - git (just light bool)
# - gitui
# - helix
# - lazygit (maybe)
# - nvim
# - obsidian (changes with system)
# - wezterm

BAT_DARK=ansi
BAT_LIGHT=OneHalfLight

CODIUM_DARK="Aura Dark (Soft Text)"
CODIUM_LIGHT="Catppuccin Latte"

CODIUM_ICON_DARK=catppuccin-mocha
CODIUM_ICON_LIGHT=catppuccin-latte

DOOM_DARK=h4s-tokyo-night
DOOM_LIGHT=doom-one-light

HELIX_DARK=tokyonight
HELIX_LIGHT=catppuccin_latte

NVIM_DARK=night
NVIM_LIGHT=day

WEZTERM_DARK=tokyonight_night
WEZTERM_LIGHT="Catppuccin Latte"

darken() {
	echo "darkening"
	sed -i '' 's/\(--theme=\)".*"/\1"'$BAT_DARK'"/' .config/bat/config
	sed -i '' 's/\("workbench.colorTheme": \)".*"/\1"'"$CODIUM_DARK"'"/' .config/codium/settings.json
	sed -i '' 's/\("workbench.iconTheme": \)".*"/\1"'$CODIUM_ICON_DARK'"/' .config/codium/settings.json
	sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1'$DOOM_DARK')/' .config/doom/config.org
	sed -i '' 's/\(.*light =\).*/\1 false/' .config/git/config
	sed -i '' 's/\(command_fg: \).*,/\1Some(Gray),/' .config/gitui/theme.ron
	sed -i '' 's/\(selection_bg: \).*,/\1Some(Rgb(11, 41, 66)),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_bg: \).*,/\1Some(Rgb(11, 41, 66)),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_extra_lines_bg: \).*,/\1Some(Rgb(11, 41, 66)),/' .config/gitui/theme.ron
	sed -i '' 's/\(theme = \)".*"/\1"'$HELIX_DARK'"/' .config/helix/config.toml
	sed -i '' 's/\(style = \)".*"/\1"'$NVIM_DARK'"/' .config/nvim/lua/plugins/display.lua
	sed -i '' 's/\(local selected_scheme = \)".*"/\1"'$WEZTERM_DARK'"/' .config/wezterm/theme.lua
}

lighten() {
	echo "lightening"
	sed -i '' 's/\(--theme=\)".*"/\1"'$BAT_LIGHT'"/' .config/bat/config
	sed -i '' 's/\("workbench.colorTheme": \)".*"/\1"'"$CODIUM_LIGHT"'"/' .config/codium/settings.json
	sed -i '' 's/\("workbench.iconTheme": \)".*"/\1"'$CODIUM_ICON_LIGHT'"/' .config/codium/settings.json
	sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1'$DOOM_LIGHT')/' .config/doom/config.org
	sed -i '' 's/\(.*light =\).*/\1 true/' .config/git/config
	sed -i '' 's/\(command_fg: \).*,/\1Some(White),/' .config/gitui/theme.ron
	sed -i '' 's/\(selection_bg: \).*,/\1Some(LightBlue),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_bg: \).*,/\1Some(LightBlue),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_extra_lines_bg: \).*,/\1Some(LightBlue),/' .config/gitui/theme.ron
	sed -i '' 's/\(theme = \)".*"/\1"'$HELIX_LIGHT'"/' .config/helix/config.toml
	sed -i '' 's/\(style = \)".*"/\1"'$NVIM_LIGHT'"/' .config/nvim/lua/plugins/display.lua
	sed -i '' 's/\(local selected_scheme = \)".*"/\1"'"$WEZTERM_LIGHT"'"/' .config/wezterm/theme.lua
}

cd ~/commons || return
if grep -q "light = true" ~/.config/git/config; then
	echo "currently: light\nswitch to: dark"
	darken
else
	echo "currently: dark\nswitch to: light"
	lighten
fi
