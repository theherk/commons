#!/usr/bin/env fish

abbr -a zellij --position command ~/projects/github.com/zellij-org/zellij/target/debug/zellij

if set -q ZELLIJ_SESSION_NAME
    echo "Already in zellij session."
else
    set -l p (basename (git root))
    if contains $p (zellij list-sessions -ns)
        zellij attach $p
    else
        zellij -s $p
    end
    zellij delete-session $p
end
