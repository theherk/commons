#!/usr/bin/env fish

# Parse arguments
set -l attach_mode 0
set -l running_mode 0
set -l active_mode 0
set -l kill_mode 0
if contains -- -a $argv
    set attach_mode 1
end
if contains -- --running $argv
    set running_mode 1
end
if contains -- --active $argv
    set active_mode 1
end
if contains -- --kill $argv
    set kill_mode 1
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

if test $kill_mode -eq 1
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
    set -l repos (zoxide query -l | rg --color=never -FxNf ~/.projects | sed s:"$HOME":~:)
    set -l killable
    for session in $running_sessions
        set -l has_nvim 0
        for sdir in (printf '%s\n' $repos | rg -N "/$session\$" | string replace '~' $HOME)
            if test -S "$sdir/_neovim"
                set has_nvim 1
                break
            end
        end
        if test $has_nvim -eq 0
            set -a killable $session
        end
    end
    if test (count $killable) -eq 0
        echo "No killable sessions (all have nvim running)."
        exit 0
    end
    set -l selection (printf '%s\n' $killable | sort | fzf --reverse --multi --header "Select sessions to kill")
    if test -z "$selection"
        exit 1
    end
    for s in $selection
        zellij delete-session $s --force
        echo "Killed: $s"
    end
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

set -l all_sessions (zellij list-sessions -n 2>/dev/null)
set -l running_sessions
set -l exited_sessions
for s in $all_sessions
    if string match -rq 'EXITED' $s
        set -a exited_sessions (echo $s | cut -d' ' -f1)
    else
        set -a running_sessions (echo $s | cut -d' ' -f1)
    end
end
set -l repos (zoxide query -l | rg --color=never -FxNf ~/.projects | sed s:"$HOME":~:)
set -l filter_names $running_sessions
if set -q ZELLIJ_SESSION_NAME
    set running_sessions (printf '%s\n' $running_sessions | string match -v $ZELLIJ_SESSION_NAME)
    set -a filter_names $ZELLIJ_SESSION_NAME
end
set -l filtered
if test (count $filter_names) -gt 0
    set filtered (printf '%s\n' $repos | rg -Nv '/'(string join '$|/' $filter_names)'$')
else
    set filtered $repos
end
set -l labeled_sessions
if test (count $running_sessions) -gt 0
    for session in $running_sessions
        set -l has_nvim 0
        for sdir in (printf '%s\n' $repos | rg -N "/$session\$" | string replace '~' $HOME)
            if test -S "$sdir/_neovim"
                set has_nvim 1
                break
            end
        end
        if test $has_nvim -eq 1
            set -a labeled_sessions "󱂬 $session "
        else
            set -a labeled_sessions "󱂬 $session"
        end
    end
end
set -l sorted_sessions (printf '%s\n' $labeled_sessions | sort)
set -l fzf_items $sorted_sessions
if test $active_mode -eq 0
    set -a fzf_items $filtered
end
set -l selection (printf '%s\n' $fzf_items | fzf --reverse | string replace -r '^󱂬 ' '' | string replace -r ' $' '')
if test -z "$selection"
    exit 1
end
set -l pdir
if string match -rq '^~|^/' $selection
    set pdir (string replace '~' $HOME $selection)
else
    set pdir (printf '%s\n' $repos | rg "/$selection\$" | head -1 | string replace '~' $HOME)
    if test -z "$pdir"
        echo "Could not resolve path for session: $selection"
        exit 1
    end
end

set -l pname (basename $pdir)

if set -q ZELLIJ_SESSION_NAME
    if not string match -q "$pname" "$ZELLIJ_SESSION_NAME"
        zellij pipe --plugin file:~/bin/zellij-switch.wasm -- "--session $pname --cwd $pdir"
    end
else
    cd $pdir
    if contains $pname $running_sessions
        zellij attach $pname
    else if contains $pname $exited_sessions
        zellij delete-session $pname
        zellij -s $pname
    else
        zellij -s $pname
    end
end
