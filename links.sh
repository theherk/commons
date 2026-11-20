#!/bin/sh
# Link configurations from this repository into $HOME.
#
# Usage: links.sh [--check]
#   --check  Change nothing; report links that are missing, wrong or blocked,
#            stray links into the repo, and repo configs that nothing links.
#
# Only flags portable to both BSD (stock macOS) and GNU ln are used, since
# this runs before Homebrew installs coreutils.

repo="$HOME/commons"
nl='
'
mode=link
case "$1" in
	--check) mode=check ;;
	"") ;;
	*)
		echo "usage: $0 [--check]" >&2
		exit 2
		;;
esac

status=0
srcs=$nl
dests=$nl

tilde() {
	case "$1" in
		"$HOME"/*) printf '~/%s' "${1#"$HOME"/}" ;;
		*) printf '%s' "$1" ;;
	esac
}

report() {
	printf '%-9s %s\n' "$1" "$2"
	status=1
}

# link SRC [DEST]: SRC is relative to the repo, DEST to $HOME (default SRC).
link() {
	src="$repo/$1"
	dest="$HOME/${2:-$1}"
	srcs="$srcs$src$nl"
	dests="$dests$dest$nl"

	if [ "$mode" = link ]; then
		if [ -d "$dest" ] && [ ! -L "$dest" ]; then
			report blocked "$(tilde "$dest") is a real directory"
		else
			ln -sfn "$src" "$dest"
		fi
	elif [ ! -e "$src" ]; then
		report nosrc "$(tilde "$src")"
	elif [ -L "$dest" ]; then
		target=$(readlink "$dest")
		[ "${target%/}" = "$src" ] || report wrong "$(tilde "$dest") -> $(tilde "${target%/}")"
	elif [ -e "$dest" ]; then
		report blocked "$(tilde "$dest")"
	else
		report missing "$(tilde "$dest")"
	fi
}

# pref DOMAIN KEY SRC: point an app's config directory setting at SRC, for
# apps that cannot read their config through a symlink.
pref() {
	src="$repo/$3"
	srcs="$srcs$src$nl"
	current=$(defaults read "$1" "$2" 2>/dev/null)

	if [ "$mode" = link ]; then
		[ "$current" = "$src" ] || defaults write "$1" "$2" -string "$src"
	elif [ "$current" != "$src" ]; then
		report pref "$1 $2 is ${current:-unset}, want $(tilde "$src")"
	fi
}

# skip SRC: tracked in the repo, but wired up by hand (e.g. an app's GUI).
skip() {
	srcs="$srcs$repo/$1$nl"
}

if [ "$mode" = link ]; then
	mkdir -p \
		~/.config/fish \
		~/.config/fish/conf.d \
		~/.config/goose \
		~/.agents \
		~/.config/opencode \
		~/"Library/Application Support/Element" \
		~/"Library/Application Support/xbar/plugins" \
		~/projects/dnb.ghe.com \
		~/projects/github.com \
		~/projects/gitlab.com \
		~/projects/gitlab.tech.dnb.no
fi

link .aliases.sh
link .bashrc
link .config/aerospace
link .config/atuin
link .config/bat
link .config/brewfile
link .config/carapace
link .config/doom
link .config/element/config.json "Library/Application Support/Element/config.json"
link .config/fish/config.fish
link .config/fish/conf.d/abbreviations.fish
link .config/fish/conf.d/functions.fish
link .config/fish/conf.d/theme-enhancements.fish
link .config/gh-dash
link .config/ghostty
link .config/git
link .config/goose/config.yaml
link .config/goose/custom_providers
link .config/goose/recipes
link .config/goose/agents .agents/agents
link .config/goose/plugins .agents/plugins
link .config/grm/dnb.ghe.com/config.toml projects/dnb.ghe.com/config.toml
link .config/grm/dnb.ghe.com/remotes.toml projects/dnb.ghe.com/remotes.toml
link .config/grm/github.com/config.toml projects/github.com/config.toml
link .config/grm/github.com/remotes.toml projects/github.com/remotes.toml
link .config/grm/gitlab.com/config.toml projects/gitlab.com/config.toml
link .config/grm/gitlab.tech.dnb.no/config.toml projects/gitlab.tech.dnb.no/config.toml
link .config/helix
link .config/hn-tui.toml
link .config/ispell
link .config/jj
link .config/jjui
link .config/lazygit
link .config/mise
link .config/neovide
link .config/nvim
link .config/nushell
link .config/opencode/opencode.json
link .config/opencode/cli.json
link .config/opencode/package.json
link .config/opencode/agents
link .config/opencode/plugins
link .config/opencode/prompts
link .config/paneru
link .config/pipes-rs
pref com.brnbw.Poof Poof.configDirectoryPath .config/poof
link .config/rex
link .config/ripgrep
link .config/starship.toml
link .config/tuicr
skip .config/tuna
link .config/wezterm
link .config/yazi
link .config/zellij
skip .config/zed
link .editorconfig
link .eslintrc
link .functions.sh
link .pypirc
link .tmux.conf
link .zprofile
link .zshrc
link bin
for f in "$repo"/bin/xbar/*; do
	[ -e "$f" ] || continue
	link "bin/xbar/${f##*/}" "Library/Application Support/xbar/plugins/${f##*/}"
done
link rayscripts

[ "$mode" = check ] || exit $status

for e in "$repo"/.config/*; do
	case "$srcs" in
		*"$nl$e$nl"* | *"$nl$e/"*) ;;
		*) report unlinked "$(tilde "$e")" ;;
	esac
done

scanned=$nl
while IFS= read -r d; do
	[ -n "$d" ] || continue
	d=${d%/*}
	case "$scanned" in *"$nl$d$nl"*) continue ;; esac
	scanned="$scanned$d$nl"
	for f in "$d"/* "$d"/.[!.]*; do
		[ -L "$f" ] || continue
		case "$dests" in *"$nl$f$nl"*) continue ;; esac
		target=$(readlink "$f")
		case "$target" in
			"$repo" | "$repo"/*) report stray "$(tilde "$f") -> $(tilde "${target%/}")" ;;
		esac
	done
done <<EOF
$dests
EOF

exit $status
