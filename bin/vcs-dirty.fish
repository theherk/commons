#!/usr/bin/env fish

# For a given directory, iterate recursively through all subdirectories finding
# git and jujutsu repositories, and for each take the following actions:
# - If there are uncommitted changes, print the path to the repository and continue.
# - If the currently checked out branch is not `main`, checkout `main`.
# - If checking out `main` fails, checkout `master` and print a warning.

function check_repo
    set repo_dir $argv[1]
    cd $repo_dir

    # Handle jujutsu repositories
    if test -d .jj
        set jj_status (jj st)
        if string match -q "*The working copy has no changes.*" $jj_status
            echo "✅ CLEAN (jujutsu): $repo_dir"
        else
            echo "❌ DIRTY (jujutsu): $repo_dir"
            set -g any_dirty 1
        end
        return
    end

    # Check for uncommitted changes in git
    set dirty (git status --porcelain --untracked-files=no)
    set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test $status -ne 0
        echo "⚠️ WARN: $repo_dir (no HEAD yet; skipping)"
        return
    end
    if test -n "$dirty"
        echo "❌ DIRTY: $repo_dir [$branch]"
        set -g any_dirty 1
        return
    else
        echo "✅ CLEAN: $repo_dir [$branch]"
    end

    if test "$branch" != "main"
        git checkout main >/dev/null 2>&1
        if test $status -ne 0
            git checkout master >/dev/null 2>&1
            if test $status -ne 0
                echo "❌ ERROR: $repo_dir could not checkout main or master"
            end
        end
    end
end

set -g any_dirty 0
for repo in (fd '^(.git|.jj)$' $argv[1] --type d --hidden --absolute-path -x dirname {} | sort -u)
    check_repo $repo
end

if test $any_dirty -ne 0
    exit 1
end
