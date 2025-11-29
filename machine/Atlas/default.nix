{ unit, ... }:
{
  imports = [
    unit.sys.btrfs
    unit.sys.nvidia

    ./hardware.nix
  ];

  home-manager.users.pop.imports = [ ./hyprland.nix ];

  networking.hostName = "Atlas";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      enable = true;
      devices = [ "nodev" ];
      useOSProber = true;
    };
  };

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "23.11";
}
