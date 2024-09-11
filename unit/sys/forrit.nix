settings: {
  flake,
  tools,
  pkgs,
  system,
  ...
}: let
  cfg = builtins.toFile "forrit.json" (builtins.toJSON settings);
  forrit-server = flake.self.inputs.forrit.outputs.forrit-server."x86_64-linux";
in {
  systemd.services.forrit-server = {
    description = "Bangumi tracker and downloader";
    requires = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    script = "${forrit-server}/bin/forrit-server ${cfg}";
  };

  networking.firewall.allowedTCPPorts = [8080];
}
