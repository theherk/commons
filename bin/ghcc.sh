#!/usr/bin/env bash

# Requires: gh extension install github/gh-copilot

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
elif [ "$REPO_TYPE" = "jj" ]; then
	BRANCH=$(jj bookmark list -r "$JJ_REV" | head -n 1)
	DIFF=$(jj diff -r "$JJ_REV")
fi

read -r -d '' PROMPT <<'EOF'
You are programmer. Generate a commit message following Conventional Commits v1.0.0.
The summary line shall be imperative, present tense, and shall not end with a period.
All lines shall be a maximum of 72 characters long.
If a body is included, which is only needed if there are many complex changes or changes requiring further explanation,
format it as a concise bullet list, each line starting with - and ending in a period. These sentences should likewise be imperative.
The body should make an effort to say only meaningful, specific things about the changes.
The summary line shall always contain a scope. e.g. "feat(config): Add new keybinding for lazygit"
If the current branch name contains a jira ticket number on the regexp format '[a-zA-z]{3,4}-[0-9]{3,}', then always use the ticket as the scope in the summary.
Return only the commit message text—no code fences, no commentary, no extra markup or explanations.
EOF

printf '\n\n' | gh copilot suggest -t shell "${PROMPT}: Current branch: ${BRANCH}, Diff: ${DIFF}" >/dev/null
