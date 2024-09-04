{
  modulesPath,
  flake,
  ...
}: {
  imports = [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"

    (flake.self.unit.sys.tailscale {isServer = true;})

    ./disk.nix
  ];

  networking = {
    hostName = "EWR";
    useDHCP = true;
  };

  home-manager.users.${flake.config.user}.imports = [];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Luxembourg";

  system.stateVersion = "24.05";
}
