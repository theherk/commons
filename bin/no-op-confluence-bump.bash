#!/usr/bin/env bash
# Usage: ./update_confluence_cloud.sh PAGE_ID
# Requires env vars:
#   CONFLUENCE_BASE_URL (e.g. https://your-domain.atlassian.net/wiki)
#   CONFLUENCE_USER     (email for cloud)
#   CONFLUENCE_TOKEN    (API token for cloud)
#
# This script does a single attempt to fetch the current page and republish
# the identical storage body with version.number = current_version + 1,
# authenticated as the API user. No retries — if it fails, it fails.
set -euo pipefail

PAGE_ID="${1:-}"
if [ -z "$PAGE_ID" ]; then
	echo "Usage: $0 PAGE_ID" >&2
	exit 2
fi

: "${CONFLUENCE_BASE_URL:?CONFLUENCE_BASE_URL must be set}"
: "${CONFLUENCE_USER:?CONFLUENCE_USER must be set}"
: "${CONFLUENCE_TOKEN:?CONFLUENCE_TOKEN must be set}"

BASE_URL="$CONFLUENCE_BASE_URL"
AUTH="${CONFLUENCE_USER}:${CONFLUENCE_TOKEN}"

GET_BODY=$(mktemp)
PUT_BODY=$(mktemp)
trap 'rm -f "$GET_BODY" "$PUT_BODY"' EXIT

http_code=$(curl -sS -u "$AUTH" -H "Accept: application/json" -o "$GET_BODY" -w "%{http_code}" \
	"${BASE_URL}/rest/api/content/${PAGE_ID}?expand=body.storage,version")

if [ "$http_code" != "200" ]; then
	if [ "$http_code" = "404" ]; then
		echo "Error: Page not found (404). Check PAGE_ID and permissions." >&2
		cat "$GET_BODY" >&2 || true
		exit 4
	fi
	echo "Error: Failed to fetch page: HTTP $http_code" >&2
	cat "$GET_BODY" >&2 || true
	exit 5
fi

current_version=$(jq '.version.number' "$GET_BODY")
title=$(jq -r '.title' "$GET_BODY")
body_value=$(jq -r '.body.storage.value' "$GET_BODY")
next_version=$((current_version + 1))

payload=$(jq -nc --arg id "$PAGE_ID" \
	--arg title "$title" \
	--arg body "$body_value" \
	--argjson ver "$next_version" \
	'{
  id: $id,
  type: "page",
  title: $title,
  body: {
    storage: {
      value: $body,
      representation: "storage"
    }
  },
  version: {
    number: $ver,
    message: "Version bump by API user to allow automated publish (no content change)"
  }
}')

put_http_code=$(curl -sS -u "$AUTH" -H "Content-Type: application/json" -o "$PUT_BODY" -w "%{http_code}" \
	-X PUT "${BASE_URL}/rest/api/content/${PAGE_ID}" -d "$payload" || true)

if [ "$put_http_code" = "200" ] || [ "$put_http_code" = "201" ]; then
	echo "Success: published version $next_version as $CONFLUENCE_USER"
	jq -r '. | {id: .id, title: .title, version: .version.number, status: .status?}' "$PUT_BODY" || true
	exit 0
fi

if [ "$put_http_code" = "409" ]; then
	echo "Conflict (409): someone edited the page between our GET and PUT. Failing as requested." >&2
	cat "$PUT_BODY" >&2 || true
	exit 6
fi

echo "Unexpected response from PUT: HTTP $put_http_code" >&2
cat "$PUT_BODY" >&2 || true
exit 7
