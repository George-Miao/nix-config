{
  modulesPath,
  flake,
  ...
}: {
  imports = [
    flake.self.nixosModules.server

    "${modulesPath}/installer/scan/not-detected.nix"

    (flake.self.unit.sys.tailscale {isServer = true;})

    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "EWR";
    useDHCP = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  home-manager.users.${flake.config.user}.imports = [];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "America/New_York";

  system.stateVersion = "23.11";
}
