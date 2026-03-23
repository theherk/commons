#!/usr/bin/env bash
# @tuna.name Open Repo
# @tuna.subtitle Open a repo in the browser
# @tuna.mode background
# @tuna.input arguments
set -euo pipefail

source "$HOME/.local-exports" 2>/dev/null || true

REPO="$1"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/repo-browse"

for f in "$CACHE_DIR"/*.list; do
    if grep -qxF "$REPO" "$f" 2>/dev/null; then
        case "$(basename "$f" .list)" in
        gh) HOST="github.com" ;;
        ghe) HOST="${GH_HOST:-}" ;;
        gl) HOST="gitlab.tech.dnb.no" ;;
        esac
        open "https://$HOST/$REPO"
        exit 0
    fi
done

open "https://github.com/$REPO"
