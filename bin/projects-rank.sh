#!/usr/bin/env bash
# projects-rank.sh: Read a frecency-ordered path list (zoxide query -l) on stdin.
# Print the paths that are in ~/.projects first, in that order, then the rest of ~/.projects.
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
cat >"$tmp"

rg --color=never -FxNf "$HOME/.projects" "$tmp" || true
rg --color=never -FxNvf "$tmp" "$HOME/.projects" || true
