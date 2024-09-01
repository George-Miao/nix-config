{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # dropbox - we don't need this in the environment. systemd unit pulls it in
    # dropbox-cli
    maestral
  ];

  # networking.firewall = {
  #   allowedTCPPorts = [17500];
  #   allowedUDPPorts = [17500];
  # };

  # systemd.user.services.dropbox = {
  #   description = "Dropbox";
  #   wantedBy = ["graphical-session.target"];
  #   environment = {
  #     QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
  #     QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
  #   };
  #   serviceConfig = {
  #     ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
  #     ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
  #     KillMode = "control-group"; # upstream recommends process
  #     Restart = "on-failure";
  #     PrivateTmp = true;
  #     ProtectSystem = "full";
  #     Nice = 10;
  #   };
  # };

  systemd.user.services.maestral = {
    description = "Open-source Dropbox client for macOS and Linux";
    wantedBy = ["network-online.target"];
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.maestral}/bin/maestral start -fv";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };
}
