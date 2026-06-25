#!/usr/bin/env bash
# Agent selector using fzf. Launches coding agents with session options.

set -euo pipefail

choice=$(printf '%s\n' \
    "resume (raicode)" \
    "new (raicode)" \
    "resume (opencode)" \
    "new (opencode)" \
    "resume (claude code)" \
    "new (claude code)" \
    "select (claude code)" | fzf --reverse --header "agent")

case "$choice" in
"resume (raicode)") exec raicode --profile oc -c ;;
"new (raicode)") exec raicode --profile oc ;;
"resume (opencode)") exec opencode -c ;;
"new (opencode)") exec opencode ;;
"resume (claude code)") exec raicode --profile cc -c ;;
"new (claude code)") exec raicode --profile cc ;;
"select (claude code)") exec raicode --profile cc -r ;;
esac
