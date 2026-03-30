#!/usr/bin/env bash
set -euo pipefail

word=$(pbpaste | head -1 | xargs)
if [ -n "$word" ]; then
    open "dict://$word"
fi
