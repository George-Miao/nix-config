{
  isServer ? false,
  autoStart ? isServer,
}: {
  pkgs,
  lib,
  secrets,
  ...
}:
with lib; {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = isServer;
    authKeyFile = builtins.toFile "tailscale-authkey" secrets.tailscale.key;
    extraSetFlags = mkIf isServer [
      "--advertise-exit-node"
    ];
  };
}
