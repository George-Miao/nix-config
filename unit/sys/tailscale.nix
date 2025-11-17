{
  isServer ? false,
  autoStart ? isServer,
  hostname ? null,
}:
{
  pkgs,
  lib,
  secrets,
  flake,
  ...
}:
{
  # Logout tailscale so any change in the configuration can take effect
  system.activationScripts.logout-tailscale = ''
    ${pkgs.tailscale}/bin/tailscale logout || true
  '';

  services.tailscale =
    let
      optional = lib.lists.optional;
      server = secrets.tailscale.server;
    in
    {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = isServer;
      authKeyFile = builtins.toFile "tailscale-authkey" secrets.tailscale.key;
      extraUpFlags = [
        "--reset"
        "--ssh"
        "--advertise-tags=tag:node"
        "--accept-dns=false"
        "--login-server=${server}"
        "--operator=${flake.config.user}"
      ]
      ++ optional isServer "--advertise-exit-node"
      ++ optional (hostname != null) "--hostname=${hostname}";
    };
}
