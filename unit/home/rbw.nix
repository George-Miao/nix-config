{
  secrets,
  pkgs,
  ...
}: let
  pinentry =
    if builtins.match pkgs.system "darwin"
    then pkgs.pinentry_mac
    else pkgs.pinentry-qt;
in {
  programs.rbw = {
    enable = true;
    settings = {inherit pinentry;} // secrets.bitwarden;
  };
}
