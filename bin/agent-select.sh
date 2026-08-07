#!/usr/bin/env bash
# Agent selector using fzf. Launches coding agents with session options.

set -euo pipefail

choice=$(printf '%s\n' \
    "resume (opencode)" \
    "new (opencode)" \
    "resume (raicode)" \
    "new (raicode)" \
    "resume (claude code)" \
    "new (claude code)" \
    "select (claude code)" \
    "new (goose)" | fzf --reverse --header "agent")

case "$choice" in
"resume (opencode)") exec opencode -c ;;
"new (opencode)") exec opencode ;;
"resume (raicode)") exec raicode --profile oc -c ;;
"new (raicode)") exec raicode --profile oc ;;
"resume (claude code)") exec raicode --profile cc -c ;;
"new (claude code)") exec raicode --profile cc ;;
"select (claude code)") exec raicode --profile cc -r ;;
"new (goose)") exec goose session ;;
esac
