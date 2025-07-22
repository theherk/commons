# Jujutsu Configuration

This directory contains Jujutsu configuration that are very similar to the git configuration.

## Files Overview

- `config.toml` - Main Jujutsu configuration file
- `conf.d/dnb-conditional.toml` - DNB-specific conditional configuration
- `ignore` - Global ignore patterns (equivalent to `.gitignore_global`)
- `commit-template.txt` - Commit message template

## Quick Setup

The configuration is automatically linked:

```fish
./commons/links.sh
```

This creates a symlink from `~/commons/.config/jj/` to `~/.config/jj/`, keeping configuration in sync.

#### Signing

- GPG signing enabled for all commits.
- Uses email as signing key identifier.

#### Editor and Pager

- Diff editor: `:builtin`
- Editor: `editor` (same as Git config)
- Pager: `delta` (same as Git config)
- Commit template: Custom template with imperative mood guidance

### DNB Repository Setup

The configuration uses conditional scopes that automatically apply DNB settings when working in DNB repository directories. This is handled in `conf.d/dnb-conditional.toml`:

#### Testing Conditional Configuration

One can verify that conditional configuration is working properly:

```bash
jj config get user.email

cd ~/personal/project
jj config get user.email
# Output: theherk@gmail.com

cd ~/projects/dnb.ghe.com/some-project
jj config get user.email
# Output: adam.lawrence.sherwood@dnb.no

# List all configuration and see which files are active
jj config list --include-defaults=false
```

## Useful Jujutsu Commands

```fish
jj log                    # View commit history
jj new                    # Create a new change
jj desc -m "message"      # Describes current changes
jj squash                 # Squash current change into parent
jj edit <revision>        # Edit a previous change
jj bookmark list          # List remote bookmarks
jj split                  # Split current change
jj duplicate              # Duplicate a change
jj rebase -d <dest>       # Rebase to destination
jj resolve                # Resolve merge conflicts
```

## Revset Aliases

The configuration includes useful revset aliases:

- `trunk` - `main@origin` (the main branch from origin)
- `mine` - `author(my-email)` (commits authored by me)

Use in commands like:

```fish
jj log -r "trunk..@"      # Show commits from trunk to current
jj log -r "mine"          # Show my commits
```

## Template Aliases

Custom templates for commit formatting:

- `commit_summary` - Shows first line of description or "(no description set)"

## Resources

- [Jujutsu Documentation](https://github.com/martinvonz/jj/blob/main/docs/README.md)
- [Git Migration Tutorial](https://github.com/martinvonz/jj/blob/main/docs/git-compatibility.md)
- [Configuration Reference](https://github.com/martinvonz/jj/blob/main/docs/config.md)
