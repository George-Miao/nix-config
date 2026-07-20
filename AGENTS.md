# Repository Guidelines

## Security & Secret Handling

Never read files under `secrets/`. Legacy secrets are protected with `git-crypt`; do not commit decrypted credentials, private keys, generated secret exports, build results, or machine-local state.

Runtime secrets come from Infisical. Nested data is stored as root-level dotted names: `github.oauth_token` maps to `secrets.github.oauth_token` during evaluation. Use `scripts/import-infisical-secrets.sh` to import JSON instead of manually placing values in the repository. The activation wrapper keeps exported JSON in a root-owned temporary directory under `/var/run` and removes it afterward.

## Project Structure & Module Organization

`flake.nix` is the `flake-parts` entry point and defines NixOS, nix-darwin, deploy-rs, package, check, formatter, and development-shell outputs. Reusable Home Manager modules live in `unit/home/`; system modules live in `unit/sys/`. `unit/default.nix` automatically imports these files and assembles presets.

Put platform-wide defaults in `system/{shared,darwin,nixos-desktop,nixos-server}/` and host-specific hardware, networking, or services in `machine/<Host>/`. Shared shell helpers belong in `lib/`, executable maintenance tools in `scripts/`, and public static files in `static/`.

## Build, Test, and Development Commands

- `nix develop`: enter the shell containing the pinned Infisical CLI and `jq`.
- `nix fmt`: format Nix files with `nixfmt-tree`.
- `nix flake check`: evaluate outputs and run deploy-rs checks.
- `nix build .#nixosConfigurations.<Host>.config.system.build.toplevel`: build one NixOS host without activating it.
- `nix build .#proxmox-lxc`: generate the Proxmox LXC image.
- `rb` or `nix run .#activate`: fetch Infisical secrets and activate the local system.
- `deploy .#<Host>`: deploy a configured remote node.

Keep this repository at `$HOME/.nix-config`; activation depends on that location.

## Coding Style & Testing

Use two-space indentation and `nixfmt-tree` output. Prefer small declarative modules. Name reusable files in lowercase kebab-case, such as `unit/sys/netbird-client.nix`; retain capitalized host directories such as `machine/Everest/`. Never edit `flake.lock` manually.

There is no dedicated unit-test framework. At minimum, run `nix fmt`, `nix flake check`, and `git diff --check`. Build the affected host output for system changes. Test scripts with `bash -n`; use mocks when testing Infisical writes. Do not activate or deploy merely to validate syntax.

## Commits & Pull Requests

History favors short subjects such as `Update` and `refactor`; prefer a concise imperative subject naming the area, for example `Update Infisical activation`. Keep commits focused. Pull requests should identify affected hosts or modules, summarize behavior, list validation commands, and highlight deployment, hardware, or secret-handling implications.
