{
  secrets,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  pinentry = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-qt;
in
{
  programs.rbw = {
    enable = true;
    settings = {
      inherit pinentry;
    }
    // secrets.bitwarden;
  };
}
