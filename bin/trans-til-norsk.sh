#!/usr/bin/env bash
# Translate clipboard content from English to Norwegian using TranslateGemma.
# Shows result as a dialog and copies it to clipboard.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEXT="$(pbpaste)"
RESULT=$("${SCRIPT_DIR}/trans.sh" English en Norwegian nb "$TEXT" 2>&1) || {
  "${SCRIPT_DIR}/alert" "Translation Error"
  exit 1
}

osascript -e "set the clipboard to \"${RESULT//\"/\\\"}\""
"${SCRIPT_DIR}/alert" "$RESULT"
