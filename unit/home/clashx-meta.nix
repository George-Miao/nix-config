{ lib, pkgs, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    pkgs.clashx-meta
  ];
}
