#!/usr/bin/env bash
# @tuna.name Switch Workspace
# @tuna.subtitle Switch to or create a wezterm workspace
# @tuna.mode background
# @tuna.input arguments
set -euo pipefail

DIR="$1"
FULL_DIR="${DIR/#\~/$HOME}"
WORKSPACE="$DIR"

EXISTING=$(wezterm cli list --format json 2>/dev/null | jq -r '.[].workspace' | sort -u | grep -xF "$WORKSPACE" || true)

if [ -n "$EXISTING" ]; then
    PANE_ID=$(wezterm cli list --format json | jq -r ".[] | select(.workspace == \"$WORKSPACE\") | .pane_id" | head -1)
    wezterm cli activate-pane --pane-id "$PANE_ID"
else
    wezterm cli spawn --new-window --workspace "$WORKSPACE" --cwd "$FULL_DIR"
fi

osascript -e 'tell application "WezTerm" to activate'
