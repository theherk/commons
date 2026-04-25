#!/usr/bin/env bash
set -euo pipefail

# Generate commit messages using LLM providers
# Usage: cmes.sh [--oneline] [--provider raicode|copilot] [jj-revision]

ONELINE=false
PROVIDER="raicode"
JJ_REV="@"

for arg in "$@"; do
	case "$arg" in
		--oneline) ONELINE=true ;;
		--provider=*) PROVIDER="${arg#--provider=}" ;;
		--provider) shift_next=true ;;
		*) if [ "${shift_next:-}" = true ]; then PROVIDER="$arg"; shift_next=false; else JJ_REV="$arg"; fi ;;
	esac
done

if [ -d .jj ]; then
	REPO_TYPE="jj"
elif [ -d .git ]; then
	REPO_TYPE="git"
else
	echo "Error: Not a Git or Jujutsu repository." >&2
	exit 1
fi

if [ "$REPO_TYPE" = "git" ]; then
	BRANCH=$(git branch --show-current)
	DIFF=$(git diff --staged)
	if [ -z "$DIFF" ]; then
		echo "Error: No staged changes. Use 'git add' first." >&2
		exit 1
	fi
else
	BRANCH=$(jj bookmark list -r "$JJ_REV" 2>/dev/null | head -n 1 || true)
	DIFF=$(jj diff --git -r "$JJ_REV")
	if [ -z "$DIFF" ] && [ "$JJ_REV" = "@" ]; then
		echo "No changes in @, trying @-..." >&2
		JJ_REV="@-"
		BRANCH=$(jj bookmark list -r "$JJ_REV" 2>/dev/null | head -n 1 || true)
		DIFF=$(jj diff --git -r "$JJ_REV")
	fi
	if [ -z "$DIFF" ]; then
		echo "Error: No changes in revision $JJ_REV." >&2
		exit 1
	fi
fi

MAX_DIFF_LINES=500
DIFF_LINES=$(echo "$DIFF" | wc -l)
if [ "$DIFF_LINES" -gt "$MAX_DIFF_LINES" ]; then
	echo "Warning: Diff is $DIFF_LINES lines, truncating to $MAX_DIFF_LINES." >&2
	DIFF=$(echo "$DIFF" | head -n "$MAX_DIFF_LINES")
fi

read -r -d '' PROMPT <<'EOF' || true
You are a programmer. Generate a commit message.
The summary line must be imperative, present tense, capitalized, and must not end with a period.
All lines must be a maximum of 72 characters long.
If the branch name or bookmark contains a Jira ticket matching [a-zA-Z]{3,4}-[0-9]{3,}, use Conventional Commits with the ticket as scope: type(PROJ-1234): Summary
Otherwise, use a plain imperative message without prefixes: Summary
Include a body only when there are many complex changes requiring explanation. Format as a bullet list with - prefix and period terminator, imperative voice.
Return only the commit message text. No code fences, no commentary, no markup.
EOF

USER_PROMPT="Branch: ${BRANCH}

Diff:
${DIFF}"

call_raicode() {
	if [ -z "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
		EXPORTS=$(/usr/local/bin/raicode manage token create --name "cmes-$(date +%s)" --export --profile cc 2>&1 | grep '^export ')
		eval "$EXPORTS"
		if [ -z "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
			echo "Error: Failed to create raicode token." >&2
			exit 1
		fi
	fi

	if [ -n "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
		AUTH_HEADER="Authorization: Bearer ${ANTHROPIC_AUTH_TOKEN}"
	else
		AUTH_HEADER="x-api-key: ${ANTHROPIC_API_KEY}"
	fi

	local model="${ANTHROPIC_DEFAULT_SONNET_MODEL:-claude-sonnet-4-20250514}"

	local json_payload
	json_payload=$(jq -n \
		--arg system "$PROMPT" \
		--arg user "$USER_PROMPT" \
		--arg model "$model" \
		'{
			model: $model,
			max_tokens: 1024,
			system: $system,
			messages: [{ role: "user", content: $user }]
		}')

	local api_url
	if [ -n "${ANTHROPIC_BASE_URL:-}" ]; then
		api_url="${ANTHROPIC_BASE_URL}/v1/messages"
	else
		api_url="https://api.anthropic.com/v1/messages"
	fi

	local response
	response=$(curl -sf "$api_url" \
		-H "Content-Type: application/json" \
		-H "$AUTH_HEADER" \
		-H "anthropic-version: 2023-06-01" \
		-d "$json_payload") || {
		echo "Error: API request failed." >&2
		exit 1
	}

	echo "$response" | jq -r '.content[0].text // empty'
}

call_copilot() {
	copilot -p "${PROMPT}

${USER_PROMPT}" --silent --allow-all | sed '/^Co-authored-by:/d'
}

case "$PROVIDER" in
	raicode) COMMIT_MESSAGE=$(call_raicode) ;;
	copilot) COMMIT_MESSAGE=$(call_copilot) ;;
	*) echo "Error: Unknown provider '$PROVIDER'. Use 'raicode' or 'copilot'." >&2; exit 1 ;;
esac

if [ -z "$COMMIT_MESSAGE" ]; then
	echo "Error: No commit message generated." >&2
	exit 1
fi

echo "$COMMIT_MESSAGE"

if command -v pbcopy >/dev/null 2>&1; then
	if [ "$ONELINE" = true ]; then
		echo -n "$(echo "$COMMIT_MESSAGE" | head -n 1)" | pbcopy
		echo "Copied summary to clipboard." >&2
	else
		echo -n "$COMMIT_MESSAGE" | pbcopy
		echo "Copied full message to clipboard." >&2
	fi
fi
