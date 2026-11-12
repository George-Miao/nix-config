{ lib, pkgs, ... }:
{
  # The flake provides Linux x86_64 and macOS ARM64 builds.
  home.packages = lib.optional (pkgs ? jlcone) pkgs.jlcone;
}
