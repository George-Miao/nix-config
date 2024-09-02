{flake, ...}: let
  unit = flake.self.unit;
  nixos = flake.self.nixosModules;
in {
  imports = [
    nixos.desktop
    unit.sys.btrfs
    unit.sys.amdgpu
    unit.sys.steam

    ./hardware.nix
    ./samba.nix
  ];

  home-manager.users.${flake.config.user}.imports = [./hyprland.nix];

  system.stateVersion = "24.05";

  networking.hostName = "Everest";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      enable = true;
      devices = ["nodev"];
      useOSProber = true;
    };
  };

  time.timeZone = "America/New_York";
}
