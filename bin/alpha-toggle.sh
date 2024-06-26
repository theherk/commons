#!/usr/bin/env sh

# items to control:
# - doom
# - helix
# - nvim
# - wezterm

X=0.85247

obfuscate() {
	echo "obfuscating"
	sed -i '' 's/\(doom\/set-frame-opacity \).*)/\1100)/' .config/doom/config.org
	sed -i '' 's/\(theme = "\).*"/\1tokyonight"/' .config/helix/config.toml # Defaults to dark.
	# sed -i '' 's/\(transparent = \)true/\1false/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(sidebars = \)"transparent"/\1"normal"/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(floats = \)"transparent"/\1"normal"/' .config/nvim/lua/plugins/display.lua
	sed -i '' 's/\(vim.g.neovide_transparency = \).*/\11/' .config/nvim/lua/config/neovide.lua
	sed -i '' 's/\(config.window_background_opacity = \).*/\11.0/' .config/wezterm/theme.lua
	sed -i '' 's/\(background = \).*\(, -- tab_bar\)/\1colors.bg\2/' .config/wezterm/theme.lua
	sed -i '' 's/\(bg_color = \).*\(, -- new_tab\)/\1colors.bg\2/' .config/wezterm/theme.lua
}

clarify() {
	echo "clarifying"
	sed -i '' 's/\(doom\/set-frame-opacity \).*)/\194)/' .config/doom/config.org
	sed -i '' 's/\(theme = "\).*"/\1base16_transparent"/' .config/helix/config.toml
	# sed -i '' 's/\(transparent = \)false/\1true/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(sidebars = \)"normal"/\1"transparent"/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(floats = \)"normal"/\1"transparent"/' .config/nvim/lua/plugins/display.lua
	sed -i '' 's/\(vim.g.neovide_transparency = \).*/\1'"$X"'/' .config/nvim/lua/config/neovide.lua
	sed -i '' 's/\(config.window_background_opacity = \).*/\1'"$X"'/' .config/wezterm/theme.lua
	sed -i '' 's/\(background = \).*\(, -- tab_bar\)/\1"none"\2/' .config/wezterm/theme.lua
	sed -i '' 's/\(bg_color = \).*\(, -- new_tab\)/\1"none"\2/' .config/wezterm/theme.lua
}

cd ~/commons || return
if grep -q "config.window_background_opacity = $X" ~/.config/wezterm/theme.lua; then
	echo "currently: transparent\nswitch to: opaque"
	obfuscate
else
	echo "currently: opaque\nswitch to: transparent"
	clarify
fi
