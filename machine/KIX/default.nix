{
  unit,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];

  networking = {
    hostName = "KIX";
    useDHCP = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  home-manager.users.pop = {
    imports = with unit.home; [
      claude-code
      copilot-cli
    ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Asia/Tokyo";

  system.stateVersion = "26.05";
}
