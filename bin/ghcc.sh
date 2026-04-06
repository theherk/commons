#!/usr/bin/env bash

# Requires: brew install copilot-cli

JJ_REV="${1:-@}"

if [ -d .jj ]; then
	REPO_TYPE="jj"
elif [ -d .git ]; then
	REPO_TYPE="git"
else
	echo "Not a Git or Jujutsu repository."
	exit 1
fi

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

read -r -d '' PROMPT <<EOF
You are a programmer. Generate a commit message.
The summary line shall be imperative, present tense, capitalized, and shall not end with a period.
All lines shall be a maximum of 72 characters long.
If a body is included, which is only needed if there are many complex changes or changes requiring further explanation,
format it as a concise bullet list, each line starting with - and ending in a period. These sentences should likewise be imperative.
The body should make an effort to say only meaningful, specific things about the changes.
If the current branch name or bookmark contains a Jira ticket number matching the regexp '[a-zA-Z]{3,4}-[0-9]{3,}', use Conventional Commits v1.0.0 format with the ticket as the scope. e.g. "feat(PROJ-1234): Add new keybinding for lazygit"
Otherwise, use a plain imperative message without conventional commit prefixes. e.g. "Add new keybinding for lazygit"
Return only the commit message text—no code fences, no commentary, no extra markup or explanations.

Current branch: ${BRANCH}

Diff:
${DIFF}
EOF

# Generate commit message
COMMIT_MESSAGE=$(copilot -p "$PROMPT" --silent --allow-all)

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
		sleep 1.1
	fi

	# Then copy summary
	echo -n "$SUMMARY" | pbcopy
	echo "📋 Summary copied to clipboard" >&2
fi
