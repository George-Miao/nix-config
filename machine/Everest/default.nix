{
  flake,
  consts,
  lib,
  ...
}: {
  imports = with flake.self.unit.sys; [
    flake.self.nixosModules.desktop

    atd
    sshd
    btrfs
    amdgpu
    steam
    obs-studio
    (tailscale {autoStart = true;})
    (scrutiny {devices = ["/dev/nvme0" "/dev/nvme1"];})
    (vector {
      hostname = "Everest";
      include_units = ["home-manager-pop"];
    })

    ./hardware.nix
    ./samba.nix
  ];

  home-manager.users.${flake.config.user} = {
    imports = [./hyprland.nix];
    programs.alacritty.settings.font.size = lib.mkForce 11;
  };

  system.stateVersion = "24.05";

  networking.hostName = "Everest";

  users.users.${flake.config.user}.openssh.authorizedKeys.keys = [
    consts.ssh
  ];

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

  #time.timeZone = "America/New_York";
  time.timeZone = "Asia/Shanghai";
}
