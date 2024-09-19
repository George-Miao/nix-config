{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    maestral
  ];

  systemd.user.services.maestral = {
    Unit.Description = "Open-source Dropbox client for macOS and Linux";
    Install.WantedBy = ["default.target"];

    Service = {
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
