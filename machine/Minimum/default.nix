{
  modulesPath,
  flake,
  ...
}:
{
  imports = [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"

    ./disk.nix
  ];

  networking = {
    hostName = "Minimum";
    useDHCP = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
