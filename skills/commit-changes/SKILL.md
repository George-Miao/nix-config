---
name: commit-changes
description: Split pending changes in a user-specified Git repository or the current workspace into meaningful, contained local Conventional Commits without pushing. Use when the user asks to commit local work, organize a worktree into commits, or create commits without publishing them.
---

# Commit Changes

1. Resolve the target from the path supplied by the user. If no path is given,
   use the current workspace. Confirm that it is a Git worktree before acting;
   do not default to `$HOME/.nix-config`.
2. Read the applicable repository instruction files before acting. Inspect the
   current branch, recent commit subjects, `git status --short`, staged and
   unstaged diffs, and untracked file names. Stop before committing on a
   detached HEAD unless the user explicitly approves it.
3. Identify credentials, secret files, generated secret exports, build results,
   and machine-local state. Never stage them. Stop and report any suspicious
   file whose safety or ownership cannot be established.
4. Group every pending change by one coherent purpose. Keep independent feature,
   fix, refactor, dependency, test, documentation, and generated-output changes
   in separate commits. Keep tests with the behavior they verify, dependency
   lockfiles with their manifest changes, and generated files with their source
   unless the repository instructions require a separate commit.
5. Preserve unrelated work and the user's staged intent. If staged changes span
   multiple groups, repartition the index without changing working-tree content.
   Do not rewrite or amend commits that existed before this task.
6. Run the repository-specified formatter and the narrowest relevant checks for
   each group. Run broader checks when a group affects shared behavior. Stop
   before committing if a required check fails, unless the user explicitly
   accepts that failure.
7. Stage only the current group with explicit paths or `git add -p`. Never use
   `git add .`, `git add -A`, or a broad directory that includes another group.
   Review the full staged diff, staged name list, staged diff statistics, and
   `git diff --cached --check` before committing.
8. Commit each group with exactly one subject line in this form:
   `type(optional-scope): imperative summary`. Use an applicable Conventional
   Commit type such as `feat`, `fix`, `refactor`, `chore`, `docs`, or `test`.
   Keep the subject concise. Do not add a body, description, co-author, or any
   other trailer. Do not bypass hooks.
9. After each commit, verify its patch and message. Confirm that the message has
   one non-empty line and that it contains no co-author trailer. Recheck the
   remaining worktree before forming the next commit.
10. Do not push, create a pull request, or otherwise publish the commits. Report
    each commit hash and subject, validation results, and all changes that remain
    uncommitted.
