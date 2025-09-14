{
  secrets,
  pkgs,
  ...
}: let
  secret = secrets.syr.smb;
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  options = [
    automount_opts
    "username=${secret.username}"
    "password=${secret.password}"
  ];
in {
  environment.systemPackages = [pkgs.cifs-utils];

  fileSystems."/data/download" = {
    inherit options;
    device = "//truenas.cgs.vec.sh/download";
    fsType = "cifs";
  };

  fileSystems."/data/photo" = {
    inherit options;
    device = "//truenas.cgs.vec.sh/photo";
    fsType = "cifs";
  };

  fileSystems."/data/video" = {
    inherit options;
    device = "//truenas.cgs.vec.sh/video";
    fsType = "cifs";
  };
}
