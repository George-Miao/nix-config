# Nix Config

This is my personal NixOS configuration.

<!--
## Directory Structure

- `/flake.nix`: entry point for the flake, including `nixosConfigurations` and `darwinConfigurations`.
- `/unit`: Configuration for each unit (package). All interesting configs happen here.
  - `/unit/default.nix`: collect all units and export as flake
  - `/unit/home`: home-manager units
  - `/unit/sys`: nixos or darwin units
- `/system`: Configuration for different systems.
  - `/system/shared`: shared configuration cross different systems
  - `/system/darwin`: MacOS config
  - `/system/nixos-desktop`: NixOS desktop config
  - `/system/nixos-server`: NixOS server config
- `/machine`: Machine-specific configuration
-->

## Notes (Mainly for myself cuz I'm forgetful)

- Units (`./unit/{home/*, sys/*}`) are "bare" in the sense that they can output to flake directly, where Machines (`./machine/*`) are not because they are wrapped by system declarations, e.g., `nixpkgs.lib.nixosSystem`/`nix-darwin.lib.darwinSystem`.
- Units are exported to `unit.{home,sys}`, in which home units are further collected into `homeModules.{core,local,server,gui}` to form four "profiles".
- Systems (`./system`) imports aforementioned "profiles" and `sys` units, then add machine-agnostic but os-dependent configurations.
- Machines (`./machine`) imports corresponding systems and `sys` units, then add machine-specific configurations.
- `deploy-rs` is used to push local changes to remote machines (configs live under `flake.deploy.nodes`).
- Secrets are managed with `git-crypt` and keys are encoded with `base64`. Decode with `echo $KEY | base64 -d`.

### Invariants

- This config **MUST** live under `$HOME/.nix-config`
