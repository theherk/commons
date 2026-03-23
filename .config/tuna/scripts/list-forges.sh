#!/usr/bin/env bash
# @tuna.name List Forges
# @tuna.subtitle Select a git forge to browse repos
# @tuna.mode inline
# @tuna.output text
set -euo pipefail

source "$HOME/.local-exports" 2>/dev/null || true

GHE_HOST="${GH_HOST:-}"
printf '%s\n' "github.com" "$GHE_HOST" "gitlab.tech.dnb.no" | grep -v '^$'
