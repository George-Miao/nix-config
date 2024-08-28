{flake, ...}: let
  unit = flake.inputs.self.unit;
  nixos = flake.inputs.self.nixosModules;
in {
  imports = [
    nixos.desktop
    unit.sys.btrfs
    unit.sys.nvidia

    ./hardware.nix
  ];

  home-manager.users.${flake.config.user}.imports = [./hyprland.nix];

  system.stateVersion = "23.11";

  networking.hostName = "Atlas";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      enable = true;
      devices = ["nodev"];
      # device = "/dev/nvme0n1p1";
      useOSProber = true;
    };
  };

  time.timeZone = "Asia/Shanghai";
}
