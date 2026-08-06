#!/usr/bin/env bash
# Ported from ~/commons/.config/opencode/plugins/zellij-notify.js
# On goose's Stop event (a turn finishes / goose goes idle), notify all other
# zellij sessions via zjstatus so you can see which pane finished working.
# The current session gets a blank notify (clears any stale indicator).
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
		msg="zjstatus::notify:: "
	else
		msg="zjstatus::notify:: $current"
	fi
	zellij --session "$session" pipe -- "$msg" >/dev/null 2>&1 || true
done <<<"$sessions"

exit 0
