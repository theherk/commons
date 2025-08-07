#!/usr/bin/env bash

# gr: Generate and open pull/merge request URLs for git repositories
# Works with both git and jj workflows

set -euo pipefail

# Handle help option
if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
	echo "gr: Generate and open pull/merge request URLs"
	echo ""
	echo "Usage: gr"
	echo ""
	echo "Creates PR/MR (platforms handle default branch automatically)"
	echo ""
	echo "Supported platforms:"
	echo "  - GitHub (github.com, *.github.com)"
	echo "  - GitLab (gitlab.*, *.gitlab.*, *.tech.dnb.no)"
	echo "  - Other platforms (defaults to GitLab-style)"
	exit 0
fi

# Detect if we're in a jj or git repository
if jj root >/dev/null 2>&1; then
	# jj workflow
	REPO_TYPE="jj"
	REPO_ROOT=$(jj root)

	# Get current bookmark on @- (parent of current change)
	CURRENT_BRANCH=$(jj log -r @- --no-graph -T "if(bookmarks, bookmarks.join(' '), '')" 2>/dev/null | head -1 | tr -d ' ')

	# If no bookmark on @-, fallback to current change bookmark
	if [[ -z "$CURRENT_BRANCH" ]]; then
		CURRENT_BRANCH=$(jj log -r @ --no-graph -T "if(bookmarks, bookmarks.join(' '), change_id.short())" 2>/dev/null | head -1 | tr -d ' ')
	fi

	# Get origin remote URL
	REMOTE_URL=$(jj git remote list 2>/dev/null | grep "^origin" | awk '{print $2}' || echo "")

elif git rev-parse --git-dir >/dev/null 2>&1; then
	# git workflow
	REPO_TYPE="git"
	REPO_ROOT=$(git rev-parse --show-toplevel)

	# Get current branch
	CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")

	# If detached HEAD, try to get branch from reflog or use HEAD
	if [[ -z "$CURRENT_BRANCH" ]]; then
		CURRENT_BRANCH="HEAD"
	fi

	# Get origin remote URL
	REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

else
	echo "Error: Not in a git or jj repository" >&2
	exit 1
fi

# Let platforms handle default branch automatically - no target needed
TARGET_BRANCH=""

# Check if we have a remote URL
if [[ -z "$REMOTE_URL" ]]; then
	echo "Error: No 'origin' remote found" >&2
	if [[ "$REPO_TYPE" == "jj" ]]; then
		echo "Available remotes:" >&2
		jj git remote list 2>/dev/null || echo "  (none found)" >&2
	else
		echo "Available remotes:" >&2
		git remote -v 2>/dev/null || echo "  (none found)" >&2
	fi
	exit 1
fi

# Check if we have a source branch
if [[ -z "$CURRENT_BRANCH" ]]; then
	echo "Error: No current branch/bookmark detected" >&2
	if [[ "$REPO_TYPE" == "jj" ]]; then
		echo "Consider creating a bookmark: jj bookmark create my-feature" >&2
	fi
	exit 1
fi

# Function to parse repository info from remote URL
parse_repo_info() {
	local url="$1"
	local host=""
	local owner=""
	local repo=""

	# Handle SSH protocol URLs with port (ssh://git@host:port/owner/repo.git)
	if [[ "$url" =~ ^ssh://git@([^:]+):([0-9]+)/(.+)/(.+)\.git$ ]]; then
		host="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
		owner="${BASH_REMATCH[3]}"
		repo="${BASH_REMATCH[4]}"
	# Handle SSH protocol URLs with port without .git suffix
	elif [[ "$url" =~ ^ssh://git@([^:]+):([0-9]+)/(.+)/(.+)$ ]]; then
		host="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
		owner="${BASH_REMATCH[3]}"
		repo="${BASH_REMATCH[4]}"
	# Handle SSH URLs with port (git@host:port/owner/repo.git)
	elif [[ "$url" =~ ^git@([^:]+):([0-9]+)/(.+)/(.+)\.git$ ]]; then
		host="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
		owner="${BASH_REMATCH[3]}"
		repo="${BASH_REMATCH[4]}"
	# Handle SSH URLs with port without .git suffix
	elif [[ "$url" =~ ^git@([^:]+):([0-9]+)/(.+)/(.+)$ ]]; then
		host="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
		owner="${BASH_REMATCH[3]}"
		repo="${BASH_REMATCH[4]}"
	# Handle SSH URLs (git@host:owner/repo.git)
	elif [[ "$url" =~ ^git@([^:]+):(.+)/(.+)\.git$ ]]; then
		host="${BASH_REMATCH[1]}"
		owner="${BASH_REMATCH[2]}"
		repo="${BASH_REMATCH[3]}"
	# Handle SSH URLs without .git suffix
	elif [[ "$url" =~ ^git@([^:]+):(.+)/(.+)$ ]]; then
		host="${BASH_REMATCH[1]}"
		owner="${BASH_REMATCH[2]}"
		repo="${BASH_REMATCH[3]}"
	# Handle HTTPS URLs with port (https://host:port/owner/repo.git)
	elif [[ "$url" =~ ^https://([^:/]+):([0-9]+)/(.+)/(.+)\.git$ ]]; then
		host="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
		owner="${BASH_REMATCH[3]}"
		repo="${BASH_REMATCH[4]}"
	# Handle HTTPS URLs with port without .git suffix
	elif [[ "$url" =~ ^https://([^:/]+):([0-9]+)/(.+)/(.+)$ ]]; then
		host="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
		owner="${BASH_REMATCH[3]}"
		repo="${BASH_REMATCH[4]}"
	# Handle HTTPS URLs (https://host/owner/repo.git)
	elif [[ "$url" =~ ^https://([^/]+)/(.+)/(.+)\.git$ ]]; then
		host="${BASH_REMATCH[1]}"
		owner="${BASH_REMATCH[2]}"
		repo="${BASH_REMATCH[3]}"
	# Handle HTTPS URLs without .git suffix
	elif [[ "$url" =~ ^https://([^/]+)/(.+)/(.+)$ ]]; then
		host="${BASH_REMATCH[1]}"
		owner="${BASH_REMATCH[2]}"
		repo="${BASH_REMATCH[3]}"
	else
		echo "Error: Unable to parse remote URL: $url" >&2
		exit 1
	fi

	echo "$host|$owner|$repo"
}

# Parse the remote URL
REPO_INFO=$(parse_repo_info "$REMOTE_URL")
IFS='|' read -r HOST OWNER REPO <<<"$REPO_INFO"

# Generate the appropriate URL based on the host
generate_pr_url() {
	local host="$1"
	local owner="$2"
	local repo="$3"
	local source="$4"
	local target="$5"

	case "$host" in
	github.com | *.github.com | dnb.ghe.com)
		# GitHub or GitHub Enterprise - let platform handle default branch
		echo "https://$host/$owner/$repo/compare/$source"
		;;
	gitlab.com | *.gitlab.com)
		# GitLab.com and GitLab instances
		echo "https://$host/$owner/$repo/-/merge_requests/new?merge_request[source_branch]=$source"
		;;
	gitlab.tech.dnb.no:2222)
		# DNB GitLab with port - use base host without port for URL
		echo "https://gitlab.tech.dnb.no/$owner/$repo/-/merge_requests/new?merge_request[source_branch]=$source"
		;;
	*)
		# Default to GitLab-style for unknown hosts
		echo "https://$host/$owner/$repo/-/merge_requests/new?merge_request[source_branch]=$source"
		;;
	esac
}

# Generate the PR/MR URL
PR_URL=$(generate_pr_url "$HOST" "$OWNER" "$REPO" "$CURRENT_BRANCH" "$TARGET_BRANCH")

echo "Opening PR/MR: $CURRENT_BRANCH → default"
echo "URL: $PR_URL"

# Open the URL in the default browser
if command -v open >/dev/null 2>&1; then
	# macOS
	open "$PR_URL"
elif command -v xdg-open >/dev/null 2>&1; then
	# Linux
	xdg-open "$PR_URL"
elif command -v start >/dev/null 2>&1; then
	# Windows
	start "$PR_URL"
else
	echo "Unable to open browser automatically. Please open this URL manually:"
	echo "$PR_URL"
fi
