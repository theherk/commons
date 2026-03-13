#!/usr/bin/env bash
# Wrapper for raicode that uses gum to select session mode.
# Used by Wezterm Cmd-R toggle to spawn raicode with session options.

set -euo pipefail

choice=$(gum choose --header "raicode" "new" "last" "select")

case "$choice" in
  new)    exec raicode ;;
  last)   exec raicode -c ;;
  select) exec raicode -r ;;
esac
