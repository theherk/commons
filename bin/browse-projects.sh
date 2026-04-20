#!/usr/bin/env bash
set -euo pipefail

osascript -e '
tell application "WezTerm" to activate
tell application "System Events"
  keystroke "p" using command down
end tell
'
