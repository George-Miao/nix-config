---
name: nix-package
description: Read, add, update, configure, or remove globally provisioned Nix packages in this Nix configuration. Use for CRUD operations on Home Manager, NixOS, or nix-darwin packages across Linux, Darwin, or both.
---

# Manage Nix Packages

## Inputs

Infer these values from the request and repository context; ask only when a missing value cannot be inferred safely:

- `package`: the software name and Nixpkgs attribute
- `operation`: read, create, update, or delete
- `scope`: `home` or `sys`
- `platform`: `linux`, `darwin`, or `both`

Default to `home` scope unless the package requires a system API, and default to `both` platforms. Treat `home` as Home Manager, `sys` as NixOS or nix-darwin, and `linux` as NixOS in this repository. Assume unstable Nixpkgs and Home Manager unless the user or repository points to another release.

## Workflow

1. Locate this repository at `$HOME/.nix-config`, read `AGENTS.md`, and inspect existing units, package declarations, config files, and imports. Never inspect `secrets/` or edit `flake.lock` manually.
2. Use `nix-search` to find package attributes and related options conveniently. Confirm important results against the selected Nixpkgs, Home Manager, NixOS, or nix-darwin source when exact availability or option behavior matters.
3. For a read, report package availability, current declarations, module/config ownership, scope, and platform without modifying files.
4. For create or update, prefer an appropriate native module API. Enable it and set its `package` option when available so one unit owns installation. Otherwise use `home.packages` in `unit/home/<name>.nix` or `environment.systemPackages` in `unit/sys/<name>.nix`.
5. When the package supports a configuration file and a sane, broadly useful default is feasible, consider adding that default. It is acceptable to omit configuration when no meaningful default exists. Provision any generated user configuration through Home Manager with `xdg.configFile` or `home.file`, following existing repository patterns; do not write directly into a user's home directory.
6. Search relevant unstable module options before editing: Home Manager for `home`, NixOS for `sys` on Linux, and nix-darwin for `sys` on Darwin. Research platforms separately when targeting both; do not assume their APIs match.
7. Guard platform-specific configuration with `lib.mkIf pkgs.stdenv.hostPlatform.isLinux` or `.isDarwin`. Keep shared configuration together only when the option and package are genuinely portable.
8. Import new units at the narrowest requested scope. Use the appropriate `unit.preset` or platform-wide system imports for broadly provisioned packages, and host-specific Home Manager or machine imports for host-only packages.
9. For update, change the owning module, package attribute, settings, scope, or platform guards consistently and remove superseded duplicates. For delete, remove the requested declaration and its owned configuration; also remove empty units and stale imports when safe. Preserve shared configuration and unrelated local work.
10. Run `nix fmt`, `git diff --check`, and targeted evaluation or builds for every affected platform or host.
11. After validation succeeds, activate the local configuration with `rb`. Do not deploy remote hosts unless the user explicitly requests it.

Report the operation, selected native API or fallback, package attribute, unit and import scope, configuration-file decision, supported platforms, validation results, and activation result.
