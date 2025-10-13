#!/usr/bin/env bash

# Simple wrapper to invoke raicode, setting the environment, then calling claude-code-acp.
# This will be used in zed agent configuration.
#
# Usage in Zed settings.json:
#   "agent_servers": {
#     "raicode": {
#       "type": "custom",
#       "command": "raicode-wrapper.sh",
#       "args": [],
#       "env": {}
#     }
#   }

set -euo pipefail

# 1. Set up raicode environment variables
eval "$(raicode manage env export)"

# 2. Find the latest claude-code-acp installation
ACP_DIR=$(ls -d "$HOME/Library/Application Support/Zed/external_agents/claude-code-acp/"*/ 2>/dev/null | sort -V | tail -1)

if [ -z "$ACP_DIR" ]; then
	echo "Error: claude-code-acp installation not found" >&2
	exit 1
fi

# 3. Execute the claude-code-acp with raicode environment
exec "${ACP_DIR}node_modules/@zed-industries/claude-code-acp/dist/index.js"
