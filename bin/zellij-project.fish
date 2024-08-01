#!/usr/bin/env fish

abbr -a zellij --position command ~/projects/github.com/zellij-org/zellij/target/debug/zellij

if set -q ZELLIJ_SESSION_NAME
    echo "Already in zellij session."
else
    set -l p (basename (git root))
    if contains $p (zellij list-sessions -ns)
        if contains $p (zellij list-sessions -n | rg EXITED | cut -d' ' -f1 | cut -d':' -f2)
            zellij delete-session $p
            zellij -s $p
        else
            zellij attach $p
        end
    else
        zellij -s $p
    end
end
