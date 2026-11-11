{
  lib,
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    # Keep the Insiders source and the host's license policy.
    package = lib.mkForce pkgs.vscode-insider;
  };
}
