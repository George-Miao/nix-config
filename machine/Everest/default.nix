{flake, ...}: let
  unit = flake.inputs.self.unit;
  nixos = flake.inputs.self.nixosModules;
in {
  imports = [
    nixos.desktop
    unit.sys.btrfs

    ./hardware.nix
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
