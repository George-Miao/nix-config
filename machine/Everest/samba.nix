{
  secrets,
  pkgs,
  ...
}:
let
  secret = secrets.syr.smb;
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  options = [
    automount_opts
    "uid=1000"
    "gid=100"
    "username=${secret.username}"
    "password=${secret.password}"
  ];
  shares = [
    "download"
    "immich"
    "photo"
    "video"
  ];
in
{
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems = builtins.listToAttrs (
    map (share: {
      name = "/data/${share}";
      value = {
        inherit options;
        device = "//truenas.cgs.vec.sh/${share}";
        fsType = "cifs";
      };
    }) shares
  );
}
