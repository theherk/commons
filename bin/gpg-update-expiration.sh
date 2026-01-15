#!/usr/bin/env bash

set -euo pipefail

DURATION="3m"

if [[ $# -lt 1 ]]; then
	echo "Usage: $0 <key-id> [subkey-id ...]" >&2
	echo "" >&2
	echo "Updates the expiration date for a GPG key and its subkeys." >&2
	echo "Duration is hardcoded to: $DURATION" >&2
	exit 1
fi

KEYID="$1"
shift

# Update the primary key
echo "Updating primary key: $KEYID"
gpg --quick-set-expire "$KEYID" "$DURATION"

# Update each subkey if provided
if [[ $# -gt 0 ]]; then
	for SUBKEYID in "$@"; do
		echo "Updating subkey: $SUBKEYID"
		gpg --quick-set-expire "$KEYID" "$DURATION" "$SUBKEYID"
	done
fi

echo "Done! GPG key expiration updated."
