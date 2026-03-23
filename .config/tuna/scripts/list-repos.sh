#!/usr/bin/env bash
# @tuna.name List Repos
# @tuna.subtitle List repos for a given forge host
# @tuna.mode inline
# @tuna.input arguments
# @tuna.output text
set -euo pipefail

source "$HOME/.local-exports" 2>/dev/null || true

HOST="$1"
GHE_HOST="${GH_HOST:-}"

case "$HOST" in
github.com) MODE="gh" ;;
"$GHE_HOST") MODE="ghe" ;;
*) MODE="gl" ;;
esac

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/repo-browse"
CACHE_FILE="$CACHE_DIR/$MODE.list"
SELF="$(realpath ~/bin/repo-browse.sh)"

mkdir -p "$CACHE_DIR"

if [ ! -f "$CACHE_FILE" ] || [ ! -s "$CACHE_FILE" ]; then
    "$SELF" --fetch "$MODE" "$HOST" | tee "$CACHE_FILE"
else
    cat "$CACHE_FILE"
    (tmp=$(mktemp) && "$SELF" --fetch "$MODE" "$HOST" >"$tmp" 2>/dev/null && [ -s "$tmp" ] && mv "$tmp" "$CACHE_FILE" || rm -f "$tmp" &) || true
fi
