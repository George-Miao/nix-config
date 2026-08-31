{
  pkgs,
  ...
}:
{
  hardware.logitech.wireless.enable = true;
  programs.solaar.enable = true;
  home-manager.users.pop.systemd.user.services.solaar = {
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
