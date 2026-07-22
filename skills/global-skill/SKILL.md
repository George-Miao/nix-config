---
name: global-skill
description: Read, create, update, or delete globally available agent skills provisioned by this Nix configuration. Use for any CRUD operation on shared skills for Claude Code, Codex, OpenCode, or Copilot CLI.
---

# Manage Global Skills

1. Locate this Nix configuration at `$HOME/.nix-config`, read `AGENTS.md`, and use `skills/` as the source of truth. Never inspect `secrets/` or edit generated copies under `~/.claude`, `~/.codex`, `~/.config/opencode`, or `~/.copilot`.
2. Determine whether the request is to read, create, update, or delete a skill. Inspect existing skills and repository references before changing anything. For a read, list, inspect, or explain the source skill without modifying it.
3. Use a concise skill name containing only lowercase letters, digits, and single hyphens. Do not overwrite or delete an existing skill unless the user requested that operation. For deletion, resolve the exact `skills/<name>` directory and remove references that would otherwise break evaluation.
4. For creation or update, use the current agent's skill-authoring workflow or scaffolder when available. Otherwise edit `skills/<name>/SKILL.md` directly and add only resources the workflow needs.
5. Put only `name` and `description` in YAML frontmatter for compatibility across all four agents. Make the description state what the skill does and when it should trigger. Write the body as concise imperative instructions.
6. Keep scripts in `scripts/`, detailed material in `references/`, and output templates in `assets/`. Test added or changed scripts. Do not add auxiliary files such as a README or changelog.
7. Preserve unrelated work. When updating or deleting, remove obsolete skill files and metadata only when they belong to the requested skill.
8. Validate every created or updated skill with the available skill validator. Then run `nix fmt` and `git diff --check`; run broader repository checks when warranted. Do not activate or deploy merely to validate.
9. Report the CRUD operation, affected skill paths, and validation results. Ask whether to reapply system activation with `rb`; after activation, the repository-managed skills become globally available to all four configured agents.
