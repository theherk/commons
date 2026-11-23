#!/usr/bin/env fish

# Kill all active zellij sessions that don't have a running neovim server.
# Skips the current session.

set -l all_sessions (zellij list-sessions -n 2>/dev/null)
set -l running_sessions
for s in $all_sessions
    if not string match -rq 'EXITED' $s
        set -a running_sessions (echo $s | cut -d' ' -f1)
    end
end

if set -q ZELLIJ_SESSION_NAME
    set running_sessions (printf '%s\n' $running_sessions | string match -v $ZELLIJ_SESSION_NAME)
end

if test (count $running_sessions) -eq 0
    echo "No other active sessions."
    exit 0
end

set -l live (zop list --json --no-tilde --live nvim.sock | jq -r '.projects[].id')
set -l killed 0

for session in $running_sessions
    if not contains -- $session $live
        zellij delete-session $session --force
        set killed (math $killed + 1)
        echo "Killed: $session"
    end
end

if test $killed -eq 0
    echo "No sessions to prune (all have nvim running)."
else
    echo "Pruned $killed session(s)."
end
