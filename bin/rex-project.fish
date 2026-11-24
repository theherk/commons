#!/usr/bin/env fish

# fzf project and session picker for Rex; the terminal twin of the native
# project_switch action. Sessions come first, then zop projects without one.
# --active lists only sessions.

set -l active_mode 0
if contains -- --active $argv
    set active_mode 1
end

set -l all (rex api call session.list | jq -r '.sessions[] | [.session_id, .label] | @tsv' 2>/dev/null)
set -l projects (zop list --json --no-tilde 2>/dev/null | jq -r '.projects[] | [.id, .path] | @tsv' 2>/dev/null)
set -l live (zop list --json --no-tilde --live nvim.sock 2>/dev/null | jq -r '.projects[].id' 2>/dev/null)

set -l labels
set -l busy
for line in $all
    set -l parts (string split \t -- $line)
    set -a busy $parts[2]
    if test "$parts[1]" = "$REX_SESSION"
        continue
    end
    if contains -- $parts[2] $live
        set -a labels "󱂬 $parts[2] "
    else
        set -a labels "󱂬 $parts[2]"
    end
end

set -l items
if test (count $labels) -gt 0
    set items (printf '%s\n' $labels | sort)
end
if test $active_mode -eq 0
    for line in $projects
        set -l parts (string split \t -- $line)
        if not contains -- $parts[1] $busy
            set -a items $parts[1]
        end
    end
end

set -l selection (printf '%s\n' $items | string match -rv '^\ *$' | fzf --reverse --tiebreak=index)
if test -z "$selection"
    exit 0
end

if string match -q '󱂬 *' -- $selection
    set -l label (string replace -r '^󱂬 ' '' -- $selection | string replace -r ' $' '')
    for line in $all
        set -l parts (string split \t -- $line)
        if test "$parts[2]" = "$label"
            rex do project_open session_id=$parts[1]
            break
        end
    end
else
    for line in $projects
        set -l parts (string split \t -- $line)
        if test "$parts[1]" = "$selection"
            rex do project_open path=$parts[2]
            break
        end
    end
end
