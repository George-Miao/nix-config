{
  secrets,
  pkgs,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {pinentry = pkgs.pinentry-qt;} // secrets.bitwarden;
  };
}
