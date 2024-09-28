settings: {
  lib,
  flake,
  tools,
  pkgs,
  system,
  ...
}: let
  cfg = builtins.toFile "forrit.json" (builtins.toJSON settings);
  port = with lib.strings; toInt (builtins.elemAt (splitString ":" settings.api.bind) 1);
  forrit-server = flake.self.inputs.forrit.outputs.forrit-server."x86_64-linux";
in {
  systemd.services.forrit-server = {
    description = "Bangumi tracker and downloader";
    requires = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    script = "${forrit-server}/bin/forrit-server ${cfg}";
  };

  networking.firewall.allowedTCPPorts = [port];
}
