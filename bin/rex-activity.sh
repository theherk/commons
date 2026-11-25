#!/usr/bin/env bash
set -euo pipefail

# fzf picker over agent activity (the native switcher's Activity tab): every
# block whose program reported a status, newest first. Selecting one jumps to it.

CLIENT="${REX_CLIENT:-$(rex client ls --json | jq -r '[.clients[] | select(.info.kind == "app")][0].client_id')}"

rows() {
    local sid=$1 label=$2 b
    for b in $(rex api call -s "$sid" session.list_blocks | jq -r '.blocks[].block_id'); do
        rex api call -s "$sid" block.method "{\"session_id\":\"$sid\",\"block_id\":\"$b\",\"method\":\"program_status\"}" 2>/dev/null |
            jq -r --arg sid "$sid" --arg b "$b" --arg label "$label" '
                (.records // []) as $r
                | ($r | map(select(.state != null and .app != null)) | sort_by(.updated_at) | last) as $x
                | select($x != null)
                | ($r | map(.title // empty) | first // ($x.app)) as $title
                | [$sid, $b, ($x.updated_at | sub("\\.[0-9]+"; "") | (.[19:]) as $z | (.[:19] + "Z" | fromdateiso8601) - (if $z == "Z" then 0 else (($z[0:1] + "1" | tonumber) * ($z[1:3] | tonumber * 3600 + ($z[4:6] | tonumber) * 60)) end)), $x.state, $title, $label] | @tsv'
    done
}

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
while IFS=$'\t' read -r sid label; do
    rows "$sid" "$label" >>"$TMP" &
done < <(rex api call session.list | jq -r '.sessions[] | [.session_id, .label] | @tsv')
wait

PICK=$(sort -t$'\t' -k3,3nr "$TMP" |
    awk -F'\t' -v now="$(date +%s)" '{
        d = now - $3; a = d < 3600 ? int(d/60) "m" : d < 86400 ? int(d/3600) "h" : int(d/86400) "d"
        printf "%s\t%s\t%-21.21s  %-12.12s  %-7s %s\n", $1, $2, $6, $5, $4, a }' |
    fzf --reverse --tiebreak=index --delimiter=$'\t' --with-nth=3 --prompt "agent> " |
    cut -f1,2) || exit 0

[ -z "$PICK" ] && exit 0
SID=${PICK%%$'\t'*}
BID=${PICK#*$'\t'}
rex -C "$CLIENT" do session.select session_id="$SID" >/dev/null
rex focus -s "$SID" "$BID" >/dev/null
