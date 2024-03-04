{flake, ...}: let
  unit = flake.inputs.self.unit;
  nixos = flake.inputs.self.nixosModules;
in {
  imports = [
    nixos.desktop
    unit.sys.btrfs
    unit.sys.nvidia

    ./hardware-configuration.nix
  ];

  home-manager.users.${flake.config.user}.imports = [./hyprland.nix];

  system.stateVersion = "23.11";

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "atlas";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  time.timeZone = "Asia/Shanghai";
}
