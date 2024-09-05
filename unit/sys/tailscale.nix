{
  isServer ? false,
  autoStart ? isServer,
}: {
  pkgs,
  lib,
  secrets,
  flake,
  ...
}: {
  services.tailscale = let
    flags =
      [
        "--operator=${flake.config.user}"
        "--accept-routes"
        "--ssh"
      ]
      ++ lib.lists.optional isServer "--advertise-exit-node";
  in {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = isServer;
    authKeyFile = builtins.toFile "tailscale-authkey" secrets.tailscale.key;
    extraSetFlags = flags;
    extraUpFlags = flags;
  };
}
