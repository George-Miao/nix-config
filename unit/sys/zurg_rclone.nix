target:
{
  pkgs,
  lib,
  secrets,
  ...
}:
let
  config = builtins.toFile "rclone.conf" ''
    [zurg]
    type = webdav
    url = ${secrets.zurg.webdav}
    vendor = other
    pacer_min_sleep = 0
  '';
  cmd = lib.strings.concatMapStrings (x: " " + x) [
    "${pkgs.rclone}/bin/rclone"
    "--config=${config}"
    "mount"
    "zurg:"
    target
    "--allow-non-empty"
    "--allow-other"
    "--uid=1000"
    "--gid=1000"
    "--umask=002"
    "--dir-cache-time=30s"
    "--vfs-cache-mode=writes"
  ];
in
{
  systemd.services.zurg_rclone = {
    description = "Rclone service for zurg";
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    script = cmd;
    postStop = ''
      fusermount -u ${target}
    '';
  };
}
