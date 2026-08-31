{
  pkgs,
  lib,
  unit,
  consts,
  inputs,
  ...
}:
{
  imports =
    let
      niri = unit.sys.niri {
        display = ''

        '';
      };
      scrutiny = unit.sys.scrutiny {
        devices = [
          # "/dev/nvme0"
        ];
      };
    in
    with unit.sys;
    [
      inputs.disko.nixosModules.disko

      logitech
      atd
      btrfs
      steam

      niri
      scrutiny

      ./disk.nix
      ./hardware.nix
    ];

  home-manager.users.pop = {
    home.packages = with pkgs; [ osu-lazer-bin ];
    programs.alacritty.settings.font.size = lib.mkForce 11;
    programs.ghostty.settings.font-size = lib.mkForce 11;
  };

  system.stateVersion = "26.05";

  networking.hostName = "Everest";

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
        edk2-uefi-shell.enable = true;
      };
    };
  };

  time.timeZone = lib.mkDefault "America/New_York";

  services.automatic-timezoned.enable = true;
}
