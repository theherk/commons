#!/usr/bin/env bash
# Wrapper for raicode that uses gum to select session mode.
# Used by Wezterm Cmd-R toggle to spawn raicode with session options.

set -euo pipefail

choice=$(gum choose --header "raicode" \
  "resume (opencode)" \
  "new (opencode)" \
  "resume (claude code)" \
  "new (claude code)" \
  "select (claude code)")

case "$choice" in
  "resume (opencode)")   exec raicode --profile oc -c ;;
  "new (opencode)")      exec raicode --profile oc ;;
  "resume (claude code)") exec raicode --profile cc -c ;;
  "new (claude code)")   exec raicode --profile cc ;;
  "select (claude code)") exec raicode --profile cc -r ;;
esac
