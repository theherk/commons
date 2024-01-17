#!/usr/bin/env sh

# items to control:
# - doom
# - helix
# - nvim
# - wezterm

obfuscate() {
	echo "obfuscating"
	sed -i '' 's/\(doom\/set-frame-opacity \).*)/\1100)/' .config/doom/config.org
	sed -i '' 's/\(theme = "\).*"/\1tokyonight"/' .config/helix/config.toml # Defaults to dark.
	# sed -i '' 's/\(transparent = \)true/\1false/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(sidebars = \)"transparent"/\1"normal"/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(floats = \)"transparent"/\1"normal"/' .config/nvim/lua/plugins/display.lua
	sed -i '' 's/\(config.window_background_opacity = \).*/\11.0/' .config/wezterm/theme.lua
}

clarify() {
	echo "clarifying"
	sed -i '' 's/\(doom\/set-frame-opacity \).*)/\194)/' .config/doom/config.org
	sed -i '' 's/\(theme = "\).*"/\1base16_transparent"/' .config/helix/config.toml
	# sed -i '' 's/\(transparent = \)false/\1true/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(sidebars = \)"normal"/\1"transparent"/' .config/nvim/lua/plugins/display.lua
	# sed -i '' 's/\(floats = \)"normal"/\1"transparent"/' .config/nvim/lua/plugins/display.lua
	sed -i '' 's/\(config.window_background_opacity = \).*/\10.94247/' .config/wezterm/theme.lua
}

cd ~/commons || return
if grep -q "config.window_background_opacity = 0.94247" ~/.config/wezterm/theme.lua; then
	echo "currently: transparent\nswitch to: opaque"
	obfuscate
else
	echo "currently: opaque\nswitch to: transparent"
	clarify
fi
