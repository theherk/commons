#!/usr/bin/env bash
set -euo pipefail

if ! pgrep -q "[Ww]ezterm"; then
    open -a WezTerm
    sleep 1.5
fi

osascript -e '
tell application "WezTerm" to activate
delay 0.3
tell application "System Events"
  keystroke "d" using command down
end tell
'
