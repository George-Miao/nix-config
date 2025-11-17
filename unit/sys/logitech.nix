{
  flake,
  pkgs,
  ...
}:
{
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  home-manager.users.${flake.config.user}.systemd.user.services.solaar = {
    Unit = {
      Description = "Logitech device manager";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      RestartSec = 2;
      Restart = "on-failure";
      ExecStart = "${pkgs.solaar}/bin/solaar -w hide";
    };
  };
}
