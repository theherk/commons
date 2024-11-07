#!/usr/bin/env fish

# Parse arguments
set -l attach_mode 0
if contains -- -a $argv
    set attach_mode 1
end

if test $attach_mode -eq 1
    # Try to get the most recent active session
    set -l sessions (zellij list-sessions -n | string match -rv 'EXITED')
    if test -z "$sessions"
        echo "No active zellij sessions found."
        exit 1
    end

    # Get the first (most recent) session
    set -l session_name (echo $sessions[1] | cut -d':' -f2 | cut -d' ' -f1)
    zellij attach $session_name
    exit 0
end

function p # Get git project directory from .projects. See alias repocache.
    set REPO (zoxide query -l | rg --color=never -FxNf ~/.projects | sed s:"$HOME":~: | fzf --reverse)
    if test -n "$REPO"
        string replace '~' $HOME $REPO
    end
end

set -l pdir (p)
if test -z "$pdir"
    exit 1
end

set -l pname (basename $pdir)

if set -q ZELLIJ_SESSION_NAME
    if not string match -q "$pname" "$ZELLIJ_SESSION_NAME"
        zellij pipe --plugin file:~/bin/zellij-switch.wasm -- "$pname::$pdir::editor"
    end
else
    cd $pdir
    if contains $pname (zellij list-sessions -ns)
        if contains $pname (zellij list-sessions -n | rg EXITED | cut -d' ' -f1 | cut -d':' -f2)
            zellij delete-session $pname
            zellij -n editor -s $pname
        else
            zellij attach $pname
        end
    else
        zellij -n editor -s $pname
    end
end
