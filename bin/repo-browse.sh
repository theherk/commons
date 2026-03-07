#!/usr/bin/env bash
set -euo pipefail

# Internal: called with --fetch <mode> <host> to do the actual API call
if [ "${1:-}" = "--fetch" ]; then
  MODE="$2"
  HOST="$3"
  case "$MODE" in
    gh)  GH_HOST=github.com gh api '/user/repos?per_page=100' --paginate -q '.[].full_name' ;;
    ghe) GH_HOST="$HOST" gh api '/user/repos?per_page=100' --paginate -q '.[].full_name' ;;
    gl)  GITLAB_HOST="$HOST" glab repo list --per-page 100 --output json | jq -r '.[].path_with_namespace' ;;
  esac
  exit 0
fi

SELF="$(realpath "$0")"

GHE_HOST="${GH_HOST:?GH_HOST not set}"
GL_HOST="gitlab.tech.dnb.no"

MODE="${1:-}"
if [ -z "$MODE" ]; then
  HOST=$(gum choose "github.com" "$GHE_HOST" "$GL_HOST" --header "Select forge") || exit 0
  case "$HOST" in
    github.com)  MODE="gh" ;;
    "$GHE_HOST") MODE="ghe" ;;
    "$GL_HOST")  MODE="gl" ;;
  esac
else
  case "$MODE" in
    gh)  HOST="github.com" ;;
    ghe) HOST="$GHE_HOST" ;;
    gl)  HOST="$GL_HOST" ;;
    *)   echo "Unknown mode: $MODE" >&2; exit 1 ;;
  esac
fi

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/repo-browse"
CACHE_FILE="$CACHE_DIR/$MODE.list"
CACHE_MAX_AGE=300  # 5 minutes — background refresh threshold

mkdir -p "$CACHE_DIR"

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] && return 0
  local age=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") ))
  [ "$age" -ge "$CACHE_MAX_AGE" ]
}

# Cold cache: fetch with spinner, write cache
if [ ! -f "$CACHE_FILE" ] || [ ! -s "$CACHE_FILE" ]; then
  REPOS=$(gum spin --title "Fetching repos from $HOST..." --show-output -- \
    "$SELF" --fetch "$MODE" "$HOST") || exit 0
  [ -z "$REPOS" ] && exit 0
  echo "$REPOS" > "$CACHE_FILE"
else
  REPOS=$(cat "$CACHE_FILE")
fi

SELECTED=$(echo "$REPOS" | fzf --reverse --prompt "repo> ") || exit 0
[ -z "$SELECTED" ] && exit 0

# Background refresh if stale (fire-and-forget)
if cache_is_stale; then
  ( "$SELF" --fetch "$MODE" "$HOST" > "$CACHE_FILE" 2>/dev/null & )
fi

open "https://${HOST}/${SELECTED}"
