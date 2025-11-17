{
  modulesPath,
  flake,
  ...
}:
{
  imports = with flake.self.unit.sys; [
    flake.self.nixosModules.server

    "${modulesPath}/installer/scan/not-detected.nix"

    # (tailscale {isServer = true;})
    (vector { hostname = "HND"; })

    ./hardware.nix
  ];

  networking = {
    hostName = "HND";
    useDHCP = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  home-manager.users.${flake.config.user}.imports = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Asia/Tokyo";

  system.stateVersion = "23.11";
}
