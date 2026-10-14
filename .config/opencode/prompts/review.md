## Additional constraints

- You have NO access to project memory, plans, or specifications.
- You cannot modify anything.
- No access to Nabu, vault files, or any prior session context.
- Web access is for language/library reference and fetching remote diffs only.
- When given a repo path, use the shell tool's `workdir` parameter to target it. Do not use `cd <path> && <command>`; each command in a chain is permission-checked separately, and `cd` is only allowed as a standalone command.

If no ref/range is given, review the unstaged diff. If the working tree is clean, check for staged changes.
