---
name: publish-nix-config
description: Split pending changes in $HOME/.nix-config into meaningful, contained Conventional Commits and push them to the current branch. Use when the user asks to commit, publish, or push changes in the Nix configuration repository.
---

# Publish Nix Config

1. Work only in `$HOME/.nix-config`. Read `AGENTS.md` before acting. Never
   inspect or stage `secrets/`, decrypted credentials, generated secret exports,
   build results, or machine-local state.
2. Inspect the current branch, remotes, upstream, `git status --short`, staged
   and unstaged diffs, and untracked file names. Do not switch branches, pull,
   merge, rebase, or modify existing commits.
3. Group every pending change by one coherent purpose. Keep independent package,
   module, host, skill, refactor, and generated-output changes in separate
   commits. Keep a generated file with its source change when they form one
   inseparable update. Do not mix unrelated cleanup into a commit.
4. Run `nix fmt`, `git diff --check`, and the narrowest relevant evaluation or
   build for each group. Run broader checks when changes affect shared
   configuration. Stop before committing if a required check fails, unless the
   user explicitly accepts that failure.
5. Stage only the current group with explicit paths or `git add -p`. Never use
   `git add .`, `git add -A`, or a broad directory that includes another group.
   Review the full staged diff, staged name list, staged diff statistics, and
   `git diff --cached --check` before committing.
6. Commit each group with exactly one subject line in this form:
   `type(optional-scope): imperative summary`. Use an applicable Conventional
   Commit type such as `feat`, `fix`, `refactor`, `chore`, `docs`, or `test`.
   Keep the subject concise. Do not add a body, description, co-author, or any
   other trailer. Do not bypass hooks.
7. After each commit, verify its patch and message. Confirm that the message has
   one non-empty line and that it contains no co-author trailer. Recheck the
   remaining working tree before forming the next commit.
8. Before pushing, inspect all commits ahead of the upstream and confirm that
   they match the requested publication. Stop and report any unexpected existing
   unpublished commit. Push the current branch to its configured upstream. If no
   upstream exists, verify the intended remote and set it with
   `git push -u <remote> HEAD`. Never force-push.
9. Report the pushed remote and branch, each commit hash and subject, validation
   results, and any changes that remain uncommitted.
