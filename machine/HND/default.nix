{
  modulesPath,
  flake,
  ...
}: {
  imports = [
    flake.self.nixosModules.server

    "${modulesPath}/installer/scan/not-detected.nix"

    (flake.self.unit.sys.tailscale {isServer = true;})

    ./hardware.nix
  ];

  networking = {
    hostName = "HND";
    useDHCP = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  home-manager.users.${flake.config.user}.imports = [];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Asia/Tokyo";

  system.stateVersion = "23.11";
}
