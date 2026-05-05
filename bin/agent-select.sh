#!/usr/bin/env bash
# Agent selector using fzf. Launches coding agents with session options.

set -euo pipefail

choice=$(printf '%s\n' \
    "resume (opencode)" \
    "new (opencode)" \
    "opencode" \
    "opencode -c" \
    "resume (claude code)" \
    "new (claude code)" \
    "select (claude code)" | fzf --reverse --header "agent")

case "$choice" in
"resume (opencode)") exec raicode --profile oc -c ;;
"new (opencode)") exec raicode --profile oc ;;
"opencode") exec opencode ;;
"opencode -c") exec opencode -c ;;
"resume (claude code)") exec raicode --profile cc -c ;;
"new (claude code)") exec raicode --profile cc ;;
"select (claude code)") exec raicode --profile cc -r ;;
esac
