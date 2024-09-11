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
  systemd.user.services.forrit-server = {
    Unit = {
      Description = "Bangumi tracker and downloader";
    };

    Service = {
      ExecStart = "${forrit-server}/bin/forrit-server ${cfg}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
