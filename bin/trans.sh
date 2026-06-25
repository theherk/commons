#!/usr/bin/env bash
# Translate text using TranslateGemma on oMLX.
# Uses /v1/completions with raw prompt because TranslateGemma's chat template
# requires structured content arrays that oMLX doesn't pass through.
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

OMLX_BASE="${OMLX_URL:-http://localhost:8000/v1}"
MODEL="${TRANSLATE_MODEL:-mlx-community--translategemma-4b-it-4bit}"

if ! curl -sf "${OMLX_BASE}/models" >/dev/null 2>&1; then
  echo "error: oMLX server not reachable at ${OMLX_BASE}" >&2
  exit 1
fi

# Prompt wraps in Gemma chat markers since we use /v1/completions directly.
# This matches the official TranslateGemma chat template output verbatim.
PROMPT="<bos><start_of_turn>user
You are a professional ${SOURCE_LANG} (${SOURCE_CODE}) to ${TARGET_LANG} (${TARGET_CODE}) translator. Your goal is to accurately convey the meaning and nuances of the original ${SOURCE_LANG} text while adhering to ${TARGET_LANG} grammar, vocabulary, and cultural sensitivities.
Produce only the ${TARGET_LANG} translation, without any additional explanations or commentary. Please translate the following ${SOURCE_LANG} text into ${TARGET_LANG}:


${TEXT}<end_of_turn>
<start_of_turn>model
"

curl -sf "${OMLX_BASE}/completions" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg model "$MODEL" \
    --arg prompt "$PROMPT" '{
    model: $model,
    prompt: $prompt,
    temperature: 0.1,
    max_tokens: 4096,
    stop: ["<end_of_turn>"]
  }')" | jq -r '.choices[0].text'
