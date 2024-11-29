{
  pkgs,
  lib,
  ...
}: let
  is_mac = with builtins; isList (match ".*darwin" pkgs.system);
  pinentry =
    if is_mac
    then pkgs.pinentry_mac
    else pkgs.pinentry-qt;
in {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryPackage = pinentry;
  };

  programs.zsh = lib.mkIf is_mac {
    initExtra = ''
      gpgconf --launch gpg-agent
    '';
    sessionVariables = {
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    };
  };
}
