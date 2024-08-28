# Nix Config

This is my personal NixOS configuration.

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

## Get started (Mainly for myself cuz I'm forgetful)

TODO

## Secrets

Secrets are managed with `git-crypt`

## Config flow

`flake.nix` imports all units and systems, which would then be exported as flake. Next, depend on which machine the activate script (`nix run .#activate`) is running on, the corresponding machine configuration will be activated and pull in the system and unit configurations it needs.

## Invariants

- The config *MUST* live under `$HOME/.nix-config`
