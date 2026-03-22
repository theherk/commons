#!/usr/bin/env bash
set -euo pipefail

# Internal: called with --fetch <mode> <host> to do the actual API call
if [ "${1:-}" = "--fetch" ]; then
    MODE="$2"
    HOST="$3"
    case "$MODE" in
    gh) GH_HOST=github.com gh api '/user/repos?per_page=100' --paginate -q '.[].full_name' ;;
    ghe) GH_HOST="$HOST" gh api '/user/repos?per_page=100' --paginate -q '.[].full_name' ;;
    gl) GITLAB_HOST="$HOST" glab repo list --per-page 100 --output json | jq -r '.[].path_with_namespace' ;;
    esac
    exit 0
fi

SELF="$(realpath "$0")"

GHE_HOST="${GH_HOST:?GH_HOST not set}"
GL_HOST="gitlab.tech.dnb.no"

MODE="${1:-}"
if [ -z "$MODE" ]; then
    HOST=$(printf '%s\n' "github.com" "$GHE_HOST" "$GL_HOST" | fzf --reverse --prompt "forge> ") || exit 0
    case "$HOST" in
    github.com) MODE="gh" ;;
    "$GHE_HOST") MODE="ghe" ;;
    "$GL_HOST") MODE="gl" ;;
    esac
else
    case "$MODE" in
    gh) HOST="github.com" ;;
    ghe) HOST="$GHE_HOST" ;;
    gl) HOST="$GL_HOST" ;;
    *)
        echo "Unknown mode: $MODE" >&2
        exit 1
        ;;
    esac
fi

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/repo-browse"
CACHE_FILE="$CACHE_DIR/$MODE.list"

mkdir -p "$CACHE_DIR"

# Cold cache: blocking fetch
if [ ! -f "$CACHE_FILE" ] || [ ! -s "$CACHE_FILE" ]; then
    REPOS=$("$SELF" --fetch "$MODE" "$HOST") || exit 0
    [ -z "$REPOS" ] && exit 0
    echo "$REPOS" >"$CACHE_FILE"
fi

# Always refresh in background for next invocation
(tmp=$(mktemp) && "$SELF" --fetch "$MODE" "$HOST" >"$tmp" 2>/dev/null && [ -s "$tmp" ] && mv "$tmp" "$CACHE_FILE" || rm -f "$tmp" &) || true

SELECTED=$(cat "$CACHE_FILE" | fzf --reverse --prompt "repo> ") || exit 0
[ -z "$SELECTED" ] && exit 0

open "https://${HOST}/${SELECTED}"
