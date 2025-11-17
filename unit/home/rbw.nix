{
  secrets,
  pkgs,
  ...
}:
let
  is_mac = with builtins; isList (match ".*darwin" pkgs.system);
  pinentry = if is_mac then pkgs.pinentry_mac else pkgs.pinentry-qt;
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
