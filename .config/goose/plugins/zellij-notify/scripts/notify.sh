#!/usr/bin/env bash
# On goose's Stop event (a turn finishes / goose goes idle), notify all other
# zellij sessions via zjstatus so you can see which pane finished working.
# The current session gets a message with no name (icon-only) to clear/reset
# any stale indicator while still showing the notify icon.
set -euo pipefail

# Hooks receive the event payload as JSON on stdin; drain it (unused here).
cat >/dev/null || true

command -v zellij >/dev/null 2>&1 || exit 0
[ -n "${ZELLIJ_SESSION_NAME:-}" ] || exit 0

current="$ZELLIJ_SESSION_NAME"
sessions="$(zellij list-sessions -ns 2>/dev/null || true)"

while IFS= read -r session; do
	[ -z "$session" ] && continue
	if [ "$session" = "$current" ]; then
		msg="zjstatus::notify::  "
	else
		msg="zjstatus::notify::  $current"
	fi
	# </dev/null is required: without it, `zellij pipe` inherits this loop's
	# stdin (the here-string with the session list) and consumes the
	# remaining lines, terminating the loop after the first session.
	zellij --session "$session" pipe -- "$msg" </dev/null >/dev/null 2>&1 || true
done <<<"$sessions"

exit 0
