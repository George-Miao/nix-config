{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs.vscode = {
    enable = true;
    package = lib.mkForce inputs.flakes.packages.${system}.vscode-insider;
  };
}
