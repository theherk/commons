#!/usr/bin/env bash
# copy-project-path.sh: Pick a zop project by id and copy its full path to the clipboard.
set -euo pipefail

selection=$(zop list --json --no-tilde | jq -r '.projects[] | [.id, .path] | @tsv' | fzf --reverse --tiebreak=index --delimiter=$'\t' --with-nth=1) || exit 0

printf '%s' "${selection#*$'\t'}" | pbcopy
