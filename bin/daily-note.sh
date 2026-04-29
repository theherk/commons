#!/usr/bin/env bash
set -euo pipefail

osascript <<'EOF'
tell application "WezTerm" to activate
tell application "System Events"
  keystroke "a" using control down
  keystroke "t"
end tell
EOF
