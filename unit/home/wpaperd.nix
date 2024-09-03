{
  nixosConfig,
  flake,
  lib,
  pkgs,
  ...
}: let
  home = nixosConfig.users.users.${flake.config.user}.home;
in {
  imports = [
    ./pop-wallpaper.nix
  ];

  programs.wpaperd = {
    enable = true;
    settings = {
      any = {
        path = "${home}/Wallpapers";
        duration = "1hr";
      };
    };
  };

  systemd.user.services.wpaperd = {
    Unit.Description = "Modern wallpaper daemon for Wayland";
    Install.WantedBy = ["hyprland-session.target"];

    Service = {
      ExecStart = "${lib.getBin pkgs.wpaperd}/bin/wpaperd -v";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
    };
  };
}
