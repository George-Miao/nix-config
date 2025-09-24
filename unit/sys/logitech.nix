{pkgs, ...}: {
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  systemd.user.services.solaar = {
    wantedBy = ["graphical-session.target"];
    script = "${pkgs.solaar}/bin/solaar -w hide";
  };
}
