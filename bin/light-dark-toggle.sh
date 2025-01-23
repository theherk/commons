#!/usr/bin/env sh

PROFILE_DIR="$HOME/Library/Application Support/zen/Profiles/y10w10po.Default (alpha)"

BAT_DARK=tokyonight_night
BAT_LIGHT=Catppuccin-latte

CODIUM_DARK="Aura Dark (Soft Text)"
CODIUM_LIGHT="Catppuccin Latte"

CODIUM_ICON_DARK=catppuccin-mocha
CODIUM_ICON_LIGHT=catppuccin-latte

DOOM_DARK=h4s-tokyo-night
DOOM_LIGHT=doom-one-light

GHOSTTY_DARK=tokyonight
GHOSTTY_LIGHT=catppuccin-latte

HELIX_DARK=base16_transparent
HELIX_LIGHT=catppuccin_latte

LAZYGIT_BG_DARK=#24283b
LAZYGIT_BG_LIGHT=#e1e2e7

NVIM_COLORSCHEME_DARK="catppuccin"
NVIM_COLORSCHEME_LIGHT="catppuccin"

# Not needed while using separate plugins.
NVIM_VARIANT_DARK=frappe
NVIM_VARIANT_LIGHT=latte

WEZTERM_DARK="Catppuccin Frappe"
WEZTERM_LIGHT="Catppuccin Latte"

YAZI_DARK="tokyo-night"
YAZI_LIGHT="catppuccin-latte"

ZELLIJ_DARK="tokyo-night"
ZELLIJ_LIGHT="gruvbox-light"

darken() {
	echo "darkening"
	osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
	sed -i '' 's/\(--theme=\)".*"/\1"'$BAT_DARK'"/' .config/bat/config
	sed -i '' 's/\("workbench.colorTheme": \)".*"/\1"'"$CODIUM_DARK"'"/' .config/codium/settings.json
	sed -i '' 's/\("workbench.iconTheme": \)".*"/\1"'$CODIUM_ICON_DARK'"/' .config/codium/settings.json
	sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1'$DOOM_DARK')/' .config/doom/config.org
	sed -i '' 's/\(.*light =\).*/\1 false/' .config/git/config
	sed -i '' 's/\(command_fg: \).*,/\1Some("Gray"),/' .config/gitui/theme.ron
	sed -i '' 's/\(selection_bg: \).*,/\1Some("#0B2942"),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_bg: \).*,/\1Some("#0B2942"),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_extra_lines_bg: \).*,/\1Some("#0B2942"),/' .config/gitui/theme.ron
	sed -i '' 's/\(theme = \).*/\1'$GHOSTTY_DARK'/' .config/ghostty/config
	sed -i '' 's/\(theme = \)".*"/\1"'$HELIX_DARK'"/' .config/helix/config.toml
	sed -i '' 's/\(selected.*BgColor: \)\[".*"\]/\1["'$LAZYGIT_BG_DARK'"]/' .config/lazygit/config.yml
	sed -i '' 's/\(pager: .*\) --light/\1 --diff-so-fancy/' .config/lazygit/config.yml
	sed -i '' 's/\(vim.cmd.colorscheme\)(".*")/\1("'"$NVIM_COLORSCHEME_DARK"'")/' .config/nvim/plugin/2-display.lua
	sed -i '' 's/\(flavour = \)".*"/\1"'$NVIM_VARIANT_DARK'"/' .config/nvim/plugin/2-display.lua
	sed -i '' 's/\(local custom = require("lualine.themes.\).*")/\1'$NVIM_COLORSCHEME_DARK'")/' .config/nvim/plugin/2-display.lua
	sed -i '' 's/\(vim.opt.background = \)".*"/\1"dark"/' .config/nvim/plugin/1-options.lua
	sed -i '' 's/\(local selected_scheme = \)".*"/\1"'"$WEZTERM_DARK"'"/' .config/wezterm/theme.lua
	sed -i '' 's/\(use = \)".*"/\1"'"$YAZI_DARK"'"/' .config/yazi/theme.toml
	sed -i '' 's/\(theme \)".*"/\1"'"$ZELLIJ_DARK"'"/' .config/zellij/config.kdl
	# sed -i '' 's/user_pref("browser\.theme\.content-theme", .);/user_pref("browser.theme.content-theme", 0);/' "$PROFILE_DIR/prefs.js"
	# sed -i '' 's/user_pref("browser\.theme\.toolbar-theme", .);/user_pref("browser.theme.toolbar-theme", 0);/' "$PROFILE_DIR/prefs.js"
}

lighten() {
	echo "lightening"
	osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
	sed -i '' 's/\(--theme=\)".*"/\1"'$BAT_LIGHT'"/' .config/bat/config
	sed -i '' 's/\("workbench.colorTheme": \)".*"/\1"'"$CODIUM_LIGHT"'"/' .config/codium/settings.json
	sed -i '' 's/\("workbench.iconTheme": \)".*"/\1"'$CODIUM_ICON_LIGHT'"/' .config/codium/settings.json
	sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1'$DOOM_LIGHT')/' .config/doom/config.org
	sed -i '' 's/\(.*light =\).*/\1 true/' .config/git/config
	sed -i '' 's/\(command_fg: \).*,/\1Some("White"),/' .config/gitui/theme.ron
	sed -i '' 's/\(selection_bg: \).*,/\1Some("LightBlue"),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_bg: \).*,/\1Some("LightBlue"),/' .config/gitui/theme.ron
	sed -i '' 's/\(cmdbar_extra_lines_bg: \).*,/\1Some("LightBlue"),/' .config/gitui/theme.ron
	sed -i '' 's/\(theme = \).*/\1'$GHOSTTY_LIGHT'/' .config/ghostty/config
	sed -i '' 's/\(theme = \)".*"/\1"'$HELIX_LIGHT'"/' .config/helix/config.toml
	sed -i '' 's/\(selected.*BgColor: \)\[".*"\]/\1["'$LAZYGIT_BG_LIGHT'"]/' .config/lazygit/config.yml
	sed -i '' 's/\(pager: .*\) --diff-so-fancy/\1 --light/' .config/lazygit/config.yml
	sed -i '' 's/\(vim.cmd.colorscheme\)(".*")/\1("'"$NVIM_COLORSCHEME_LIGHT"'")/' .config/nvim/plugin/2-display.lua
	sed -i '' 's/\(flavour = \)".*"/\1"'$NVIM_VARIANT_LIGHT'"/' .config/nvim/plugin/2-display.lua
	sed -i '' 's/\(local custom = require("lualine.themes.\).*")/\1'$NVIM_COLORSCHEME_LIGHT'")/' .config/nvim/plugin/2-display.lua
	sed -i '' 's/\(vim.opt.background = \)".*"/\1"light"/' .config/nvim/plugin/1-options.lua
	sed -i '' 's/\(local selected_scheme = \)".*"/\1"'"$WEZTERM_LIGHT"'"/' .config/wezterm/theme.lua
	sed -i '' 's/\(use = \)".*"/\1"'"$YAZI_LIGHT"'"/' .config/yazi/theme.toml
	sed -i '' 's/\(theme \)".*"/\1"'"$ZELLIJ_LIGHT"'"/' .config/zellij/config.kdl
	# sed -i '' 's/user_pref("browser\.theme\.content-theme", .);/user_pref("browser.theme.content-theme", 1);/' "$PROFILE_DIR/prefs.js"
	# sed -i '' 's/user_pref("browser\.theme\.toolbar-theme", .);/user_pref("browser.theme.toolbar-theme", 1);/' "$PROFILE_DIR/prefs.js"
}

cd ~/commons || return
if grep -q "light = true" ~/.config/git/config; then
	echo "currently: light\nswitch to: dark"
	darken
else
	echo "currently: dark\nswitch to: light"
	lighten
fi
