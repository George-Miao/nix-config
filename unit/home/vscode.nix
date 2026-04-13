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
    package = lib.mkForce (
      pkgs.callPackage inputs.flakes.packages.${system}.vscode-insider.override { }
    );
  };
}
