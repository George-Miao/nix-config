{flake, ...}: {
  imports = with flake.self.unit.sys; [
    flake.self.nixosModules.desktop

    btrfs
    amdgpu
    steam
    (tailscale {autoStart = true;})

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
