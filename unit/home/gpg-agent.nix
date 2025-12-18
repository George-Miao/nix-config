{
  pkgs,
  lib,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  pinentry = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gnome3;
in
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pinentry;
  };

  programs.zsh = lib.mkIf isDarwin {
    initContent = ''
      gpgconf --launch gpg-agent
    '';
    sessionVariables = {
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    };
  };
}
