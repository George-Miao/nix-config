{ config, pkgs, ... }:
{
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  environment.systemPackages = [
    pkgs.bindfs
    pkgs.waydroid-helper
  ];

  # Show host ownership without changing Android file ownership.
  fileSystems."/data/waydroid" = {
    device = "${config.users.users.pop.home}/.local/share/waydroid/data/media/0";
    fsType = "fuse.bindfs";
    options = [
      "mirror=pop"
      "nofail"
      "x-systemd.automount"
    ];
  };

  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  };

  home-manager.users.pop.systemd.user.services.waydroid-monitor = {
    Unit = {
      Description = "Waydroid session D-Bus monitor";
      After = [ "dbus.service" ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.waydroid-helper}/bin/waydroid-helper --start-monitor";
      StandardOutput = "journal";
      StandardError = "journal";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
