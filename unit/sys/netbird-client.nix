{pkgs, ...}: let
  env = {
    NB_MANAGEMENT_SERVER = "https://netbird.miao.dev";
    NB_ADMIN_SERVER = "https://netbird.miao.dev";
    NB_SETUP_KEY = "662EDEA5-93EF-4840-8495-C7035506A21D";
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
