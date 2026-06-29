#!/usr/bin/env bash
# Translate clipboard content from Norwegian to English using TranslateGemma.
# Shows result as a macOS dialog and copies it to clipboard.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEXT="$(pbpaste)"
RESULT=$("${SCRIPT_DIR}/trans.sh" Norwegian nb English en "$TEXT" 2>&1) || {
  osascript -e "display dialog \"${RESULT//\"/\\\"}\" with title \"Translation Error\" buttons {\"OK\"} default button \"OK\""
  exit 1
}

osascript -e "set the clipboard to \"${RESULT//\"/\\\"}\"" -e "display dialog \"${RESULT//\"/\\\"}\" with title \"To English\" buttons {\"OK\"} default button \"OK\""
