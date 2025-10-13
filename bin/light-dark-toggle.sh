#!/usr/bin/env sh

PROFILE_DIR="$HOME/Library/Application Support/zen/Profiles/y10w10po.Default (alpha)"

BAT_DARK="Catppuccin Frappe"
BAT_LIGHT="Catppuccin Latte"

DOOM_DARK=h4s-tokyo-night
DOOM_LIGHT=doom-one-light

FISH_DARK="Catppuccin Frappe"
FISH_LIGHT="Catppuccin Latte"

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
WEZTERM_LIGHT="Catppuccin Latte (Gogh)"

YAZI_DARK="catppuccin-frappe"
YAZI_LIGHT="catppuccin-latte"

ZELLIJ_DARK="catppuccin-frappe"
ZELLIJ_LIGHT="gruvbox-light"

HN_DARK='[theme.palette]
# Catppuccin Frappe colors
background = "#303446"
foreground = "#c6d0f5"
selection_background = "#414559"
selection_foreground = "#c6d0f5"
black = "#414559"
blue = "#8caaee"
cyan = "#81c8be"
green = "#a6d189"
magenta = "#ca9ee6"
red = "#e78284"
white = "#949cbb"
yellow = "#e5c890"
light_black = "#51576d"
light_white = "#b5bfe2"
light_red = "#ea999c"
light_magenta = "#f4b8e4"
light_green = "#a6d189"
light_cyan = "#99d1db"
light_blue = "#85c1dc"
light_yellow = "#ef9f76"

[theme.component_style]

title_bar = { front = "#949cbb", back = "#414559", effect = "bold" }

current_story_tag = { front = "#c6d0f5", back = "#51576d", effect = "bold" }
matched_highlight = { front = "#414559", back = "#a6d189" }
metadata = { front = "#949cbb" }
username = { effect = "bold" }
loading_bar = { front = "#ef9f76", back = "#303446" }
header = { front = "#414559", effect = "bold" }
quote = { front = "#c6d0f5" }
italic = { effect = "italic" }
bold = { effect = "bold" }
single_code_block = { back = "#51576d", front = "#c6d0f5" }
multiline_code_block = { front = "#51576d", effect = "bold" }
link = { front = "#81c8be" }
link_id = { front = "#414559", back = "#e5c890" }
ask_hn = { front = "#e78284", effect = "bold" }
tell_hn = { front = "#e5c890", effect = "bold" }
show_hn = { front = "#8caaee", effect = "bold" }
launch_hn = { front = "#a6d189", effect = "bold" }'
HN_LIGHT='
[theme.palette]
# Catppuccin Latte colors
background = "#eff1f5"
foreground = "#4c4f69"
selection_background = "#ccd0da"
selection_foreground = "#4c4f69"
black = "#5c5f77"
blue = "#1e66f5"
cyan = "#179299"
green = "#40a02b"
magenta = "#ea76cb"
red = "#d20f39"
white = "#acb0be"
yellow = "#df8e1d"
light_black = "#6c6f85"
light_white = "#bcc0cc"
light_red = "#e64553"
light_magenta = "#8839ef"
light_green = "#40a02b"
light_cyan = "#04a5e5"
light_blue = "#209fb5"
light_yellow = "#fe640b"

[theme.component_style]

title_bar = { front = "#acb0be", back = "#ccd0da", effect = "bold" }

current_story_tag = { front = "#4c4f69", back = "#ccd0da", effect = "bold" }
matched_highlight = { front = "#eff1f5", back = "#40a02b" }
metadata = { front = "#8c8fa1" }
username = { effect = "bold" }
loading_bar = { front = "#fe640b", back = "#eff1f5" }
header = { front = "#5c5f77", effect = "bold" }
quote = { front = "#4c4f69" }
italic = { effect = "italic" }
bold = { effect = "bold" }
single_code_block = { back = "#ccd0da", front = "#4c4f69" }
multiline_code_block = { front = "#6c6f85", effect = "bold" }
link = { front = "#179299" }
link_id = { front = "#5c5f77", back = "#df8e1d" }
ask_hn = { front = "#d20f39", effect = "bold" }
tell_hn = { front = "#df8e1d", effect = "bold" }
show_hn = { front = "#1e66f5", effect = "bold" }
launch_hn = { front = "#40a02b", effect = "bold" }'

darken() {
	echo "darkening"
	yes | fish -c 'fish_config theme save "'"$FISH_DARK"'"'
	osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
	echo "$HN_DARK" >~/.config/hn-tui.toml
	sed -i '' 's/\(--theme=\)".*"/\1"'"$BAT_DARK"'"/' .config/bat/config
	sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1'$DOOM_DARK')/' .config/doom/config.org
	sed -i '' 's/\(.*light =\).*/\1 false/' .config/git/config
	sed -i '' 's/\(theme = \).*/\1'"$GHOSTTY_DARK"'/' .config/ghostty/config
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
	yes | fish -c 'fish_config theme save "'"$FISH_LIGHT"'"'
	osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
	echo "$HN_LIGHT" >~/.config/hn-tui.toml
	sed -i '' 's/\(--theme=\)".*"/\1"'"$BAT_LIGHT"'"/' .config/bat/config
	sed -i '' 's/(\(setq doom-theme '\''\).*)/(\1'$DOOM_LIGHT')/' .config/doom/config.org
	sed -i '' 's/\(.*light =\).*/\1 true/' .config/git/config
	sed -i '' 's/\(theme = \).*/\1'"$GHOSTTY_LIGHT"'/' .config/ghostty/config
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
