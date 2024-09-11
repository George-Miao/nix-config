{
  isServer ? false,
  autoStart ? isServer,
  hostname ? null,
}: {
  pkgs,
  lib,
  secrets,
  flake,
  ...
}: {
  services.tailscale = let
    optional = lib.lists.optional;
    server = secrets.tailscale.server;
  in {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = isServer;
    authKeyFile = builtins.toFile "tailscale-authkey" secrets.tailscale.key;
    extraUpFlags =
      [
        "--reset"
        "--ssh"
        "--accept-dns=false"
        "--login-server=${server}"
        "--operator=${flake.config.user}"
      ]
      ++ optional isServer "--advertise-exit-node"
      ++ optional (hostname != null) "--hostname=${hostname}";
  };
}
