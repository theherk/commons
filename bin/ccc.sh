#!/usr/bin/env bash

# Claude Code Commit - Generate conventional commit messages using Claude API
# Requires: raicode for API authentication

# Always set up raicode environment (prioritize gateway over personal API key)
if [ -z "$ANTHROPIC_AUTH_TOKEN" ]; then
	# Generate a token and export the environment
	RAICODE_OUTPUT=$(/usr/local/bin/raicode manage token create --name "ccc-$(date +%s)" --export 2>&1)

	# Extract just the export statements (filter out comments)
	EXPORTS=$(echo "$RAICODE_OUTPUT" | grep '^export ')

	# Evaluate the exports and verify
	eval "$EXPORTS"
	if [ -z "$ANTHROPIC_AUTH_TOKEN" ]; then
		echo "Error: Failed to create raicode token." >&2
		echo "Raicode output:" >&2
		echo "$RAICODE_OUTPUT" >&2
		exit 1
	fi
fi

JJ_REV="${1:-@}"

# Check for repository type
if [ -d .jj ]; then
	REPO_TYPE="jj"
elif [ -d .git ]; then
	REPO_TYPE="git"
else
	echo "Error: Not a Git or Jujutsu repository." >&2
	exit 1
fi

# Extract diff and branch info
if [ "$REPO_TYPE" = "git" ]; then
	BRANCH=$(git branch --show-current)
	DIFF=$(git diff --staged)

	if [ -z "$DIFF" ]; then
		echo "Error: No staged changes in git. Use 'git add' first." >&2
		exit 1
	fi
elif [ "$REPO_TYPE" = "jj" ]; then
	BRANCH=$(jj bookmark list -r "$JJ_REV" | head -n 1)
	DIFF=$(jj diff --git -r "$JJ_REV")

	# If no changes in the specified revision, try the previous one
	if [ -z "$DIFF" ]; then
		if [ "$JJ_REV" = "@" ]; then
			echo "No changes in @, trying @-..." >&2
			JJ_REV="@-"
			BRANCH=$(jj bookmark list -r "$JJ_REV" | head -n 1)
			DIFF=$(jj diff --git -r "$JJ_REV")

			if [ -z "$DIFF" ]; then
				echo "Error: No changes in revision $JJ_REV." >&2
				exit 1
			fi
		else
			echo "Error: No changes in revision $JJ_REV." >&2
			exit 1
		fi
	fi
fi

# Check for required environment variables (set by raicode)
# raicode sets ANTHROPIC_AUTH_TOKEN for gateway authentication
if [ -z "$ANTHROPIC_AUTH_TOKEN" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
	echo "Error: Neither ANTHROPIC_AUTH_TOKEN nor ANTHROPIC_API_KEY is set." >&2
	echo "Run: eval \"\$(/usr/local/bin/raicode manage token create --name \"mbp-commit\" --export)\"" >&2
	exit 1
fi

# Determine which auth method to use
if [ -n "$ANTHROPIC_AUTH_TOKEN" ]; then
	AUTH_HEADER="Authorization: Bearer ${ANTHROPIC_AUTH_TOKEN}"
else
	AUTH_HEADER="x-api-key: ${ANTHROPIC_API_KEY}"
fi

# Build the prompt
read -r -d '' SYSTEM_PROMPT <<'EOF'
You are a programmer. Generate a commit message following Conventional Commits v1.0.0.
The summary line shall be imperative, present tense, and shall not end with a period.
All lines shall be a maximum of 72 characters long.
If a body is included, which is only needed if there are many complex changes or changes requiring further explanation,
format it as a concise bullet list, each line starting with - and ending in a period. These sentences should likewise be imperative.
The body should make an effort to say only meaningful, specific things about the changes.
The summary line shall always contain a scope. e.g. "feat(config): Add new keybinding for lazygit"
If the current branch name contains a jira ticket number on the regexp format '[a-zA-z]{3,4}-[0-9]{3,}', then always use the ticket as the scope in the summary.
Return only the commit message text—no code fences, no commentary, no extra markup or explanations.
EOF

USER_PROMPT="Current branch: ${BRANCH}

Diff:
${DIFF}"

# Determine model to use (prefer raicode environment variable)
MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL:-claude-sonnet-4-20250514}"

# Build JSON payload
JSON_PAYLOAD=$(jq -n \
	--arg system "$SYSTEM_PROMPT" \
	--arg user "$USER_PROMPT" \
	--arg model "$MODEL" \
	'{
		model: $model,
		max_tokens: 1024,
		system: $system,
		messages: [
			{
				role: "user",
				content: $user
			}
		]
	}')

# Determine API endpoint
if [ -n "$ANTHROPIC_BASE_URL" ]; then
	API_URL="${ANTHROPIC_BASE_URL}/v1/messages"
else
	API_URL="https://api.anthropic.com/v1/messages"
fi

# Make API call
RESPONSE=$(curl -s "$API_URL" \
	-H "Content-Type: application/json" \
	-H "$AUTH_HEADER" \
	-H "anthropic-version: 2023-06-01" \
	-d "$JSON_PAYLOAD")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' >/dev/null 2>&1; then
	echo "Error: API call failed" >&2
	echo "$RESPONSE" | jq -r '.error.message' >&2
	exit 1
fi

# Extract commit message
COMMIT_MESSAGE=$(echo "$RESPONSE" | jq -r '.content[0].text')

if [ -z "$COMMIT_MESSAGE" ] || [ "$COMMIT_MESSAGE" = "null" ]; then
	echo "Error: Failed to extract commit message from API response" >&2
	exit 1
fi

# Output the full commit message
echo "$COMMIT_MESSAGE"

# Copy to clipboard: first body (line 3 onward), then summary (line 1)
if command -v pbcopy >/dev/null 2>&1; then
	# Extract body (line 3 onward)
	BODY=$(echo "$COMMIT_MESSAGE" | tail -n +3)

	# Extract summary (line 1)
	SUMMARY=$(echo "$COMMIT_MESSAGE" | head -n 1)

	# Copy body first (if it exists and has non-whitespace content)
	if [ -n "$(echo "$BODY" | tr -d '[:space:]')" ]; then
		echo -n "$BODY" | pbcopy
		echo "📋 Body copied to clipboard" >&2
		sleep 1.1 # Brief delay to allow clipboard to settle
	fi

	# Then copy summary
	echo -n "$SUMMARY" | pbcopy
	echo "📋 Summary copied to clipboard" >&2
fi
