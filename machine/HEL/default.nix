{
  modulesPath,
  unit,
  ...
}:
{
  imports = with unit.sys; [
    "${modulesPath}/installer/scan/not-detected.nix"

    # (tailscale {isServer = true;})
    (vector { hostname = "HEL"; })

    ./hardware.nix
  ];

  networking = {
    hostName = "HEL";
    useDHCP = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  home-manager.users.pop.imports = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Helsinki";

  system.stateVersion = "23.11";
}
