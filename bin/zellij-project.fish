#!/usr/bin/env fish

# Parse arguments
set -l attach_mode 0
set -l running_mode 0
if contains -- -a $argv
    set attach_mode 1
end
if contains -- --running $argv
    set running_mode 1
end

if test $running_mode -eq 1
    set -l sessions (zellij list-sessions -n | string match -rv 'EXITED')
    if test -z "$sessions"
        echo "No active zellij sessions found."
        exit 1
    end

    set -l session_name (printf '%s\n' $sessions | fzf --reverse | cut -d' ' -f1)
    if test -z "$session_name"
        exit 1
    end
    zellij attach $session_name
    exit 0
end

if test $attach_mode -eq 1
    set -l sessions (zellij list-sessions -n | string match -rv 'EXITED')
    if test -z "$sessions"
        echo "No active zellij sessions found."
        exit 1
    end

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
        zellij pipe --plugin file:~/bin/zellij-switch.wasm -- "--session $pname --cwd $pdir"
    end
else
    cd $pdir
    if contains $pname (zellij list-sessions -ns)
        if contains $pname (zellij list-sessions -n | rg EXITED | cut -d' ' -f1 | cut -d':' -f2)
            zellij delete-session $pname
            zellij -s $pname
        else
            zellij attach $pname
        end
    else
        zellij -s $pname
    end
end
