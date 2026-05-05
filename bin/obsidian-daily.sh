#!/bin/sh
# Open Obsidian daily note in nvim.
# Usage: obsidian-daily.sh [yesterday|today|tomorrow]
# Default: today

day="${1:-today}"

case "$day" in
    yesterday) cmd="Obsidian yesterday" ;;
    today)     cmd="Obsidian today" ;;
    tomorrow)  cmd="Obsidian tomorrow" ;;
    *)         echo "Usage: obsidian-daily.sh [yesterday|today|tomorrow]" >&2; exit 1 ;;
esac

cd ~/vaults/brain && exec nvim "+$cmd"
