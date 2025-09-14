{
  pkgs,
  secrets,
  ...
}: let
  env = {
    NB_MANAGEMENT_SERVER = secrets.netbird.domain;
    NB_ADMIN_SERVER = secrets.netbird.domain;
    NB_SETUP_KEY = secrets.netbird.setup_key;
    NB_ALLOW_SERVER_SSH = "true";
  };
in {
  services.netbird = {
    enable = true;
    ui.enable = true;
    tunnels.default = {
      environment = env;
    };
  };
  programs.zsh.shellInit = ''
    source <(${pkgs.netbird}/bin/netbird completion zsh)
  '';
  systemd.services.netbird.environment = env;
}
