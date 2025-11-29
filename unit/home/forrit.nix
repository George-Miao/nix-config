settings:
{
  inputs,
  pkgs,
  system,
  ...
}:
let
  cfg = builtins.toFile "forrit.json" (builtins.toJSON settings);
  forrit-server = inputs.forrit.outputs.forrit-server."x86_64-linux";
in
{
  systemd.user.services.forrit-server = {
    Unit.Description = "Bangumi tracker and downloader";

    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "simple";
      ExecStart = "${forrit-server}/bin/forrit-server ${cfg}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
