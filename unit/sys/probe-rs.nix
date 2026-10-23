{
  pkgs,
  ...
}:
let
  probeRsUdevRules = pkgs.runCommand "probe-rs-udev-rules" { } ''
    install -Dm644 ${
      pkgs.fetchurl {
        url = "https://probe.rs/files/69-probe-rs.rules";
        hash = "sha256-CfLqWaVzR2h2ZxhN/NETb2Zj38D/3BHrjrjZjzHatF0=";
      }
    } $out/lib/udev/rules.d/69-probe-rs.rules
  '';
in
{
  environment.systemPackages = [
    pkgs.probe-rs-tools
  ];

  users.groups.plugdev.members = [ "pop" ];

  services.udev.packages = [ probeRsUdevRules ];
}
