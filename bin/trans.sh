#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: trans.sh <source_lang> <source_code> <target_lang> <target_code> <text>" >&2
  exit 1
}

[[ $# -lt 4 ]] && usage

SOURCE_LANG="$1"
SOURCE_CODE="$2"
TARGET_LANG="$3"
TARGET_CODE="$4"
shift 4

if [[ $# -gt 0 ]]; then
  TEXT="$*"
else
  TEXT="$(pbpaste)"
fi

PROMPT="You are a professional ${SOURCE_LANG} (${SOURCE_CODE}) to ${TARGET_LANG} (${TARGET_CODE}) translator. Your goal is to accurately convey the meaning and nuances of the original ${SOURCE_LANG} text while adhering to ${TARGET_LANG} grammar, vocabulary, and cultural sensitivities.
Produce only the ${TARGET_LANG} translation, without any additional explanations or commentary. Please translate the following ${SOURCE_LANG} text into ${TARGET_LANG}:


${TEXT}"

ollama run translategemma:4b "${PROMPT}"
