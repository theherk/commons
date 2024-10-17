#!/usr/bin/env fish

# Get all dangling commits
set dangling_commits (git fsck --no-reflog | grep "dangling commit" | awk '{print $3}')

# Loop through each dangling commit
for commit in $dangling_commits
    echo "Commit: $commit"
    echo ----------------------------------------

    # Show the commit message
    git log -1 --pretty=format:"%s" $commit
    echo ""

    # Show the patch
    git show $commit

    echo ""
    echo "========================================"
    echo "Press Enter to continue, or Ctrl+C to exit"
    read
end
