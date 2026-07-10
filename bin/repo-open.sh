#!/usr/bin/env bash
# repo-open.sh: Open the current git/jj repository root in the browser.
set -euo pipefail

# Resolve repo root and remote URL
if jj root >/dev/null 2>&1; then
    REPO_ROOT=$(jj root)
    REMOTE_URL=$(jj git remote list 2>/dev/null | grep "^origin" | awk '{print $2}' | head -1)
else
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    REMOTE_URL=$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || echo "")
fi

if [[ -z "$REMOTE_URL" ]]; then
    echo "Error: No 'origin' remote found in $REPO_ROOT" >&2
    exit 1
fi

# Normalize remote URL to https
url="$REMOTE_URL"
# SSH: git@host:owner/repo.git or user@host:owner/repo.git
if [[ "$url" =~ ^[^@]+@([^:]+):(.+)$ ]]; then
    host="${BASH_REMATCH[1]}"
    path="${BASH_REMATCH[2]%.git}"
    url="https://$host/$path"
# ssh:// protocol
elif [[ "$url" =~ ^ssh://[^@]+@([^/:]+)(:[0-9]+)?/(.+)$ ]]; then
    host="${BASH_REMATCH[1]}"
    path="${BASH_REMATCH[3]%.git}"
    url="https://$host/$path"
else
    url="${url%.git}"
fi

open "$url"
