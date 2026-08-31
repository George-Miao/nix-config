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
        battery = true;
        brightness = true;
        display = ''
          output "China Star Optoelectronics Technology Co., Ltd MND508ZB1-1 Unknown" {
            scale 1.7
          }
        '';
        extraKeybinds = ''
          XF86AudioPrev allow-when-locked=true {
              spawn "${lib.getExe pkgs.playerctl}" "previous"
          }
          XF86AudioPlay allow-when-locked=true {
              spawn "${lib.getExe pkgs.playerctl}" "play-pause"
          }
          XF86AudioNext allow-when-locked=true {
              spawn "${lib.getExe pkgs.playerctl}" "next"
          }
          XF86MonBrightnessDown allow-when-locked=true {
              spawn "${lib.getExe pkgs.brightnessctl}" "--class=backlight" "set" "5%-"
          }
          XF86MonBrightnessUp allow-when-locked=true {
              spawn "${lib.getExe pkgs.brightnessctl}" "--class=backlight" "set" "+5%"
          }
          XF86RFKill allow-when-locked=true repeat=false {
              spawn "${lib.getExe' pkgs.util-linux "rfkill"}" "toggle" "all"
          }
          XF86AudioMedia repeat=false {
              spawn "${lib.getExe pkgs.playerctl}" "play-pause"
          }
        '';
        gestureSwipeFingers = "4";
        gaps = "5";
        threeFingerDrag = true;
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
      inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3

      fprintd
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
    home.packages = with pkgs; [
      networkmanagerapplet
      osu-lazer-bin
    ];
    programs.alacritty.settings.font.size = lib.mkForce 11;
    programs.ghostty.settings.font-size = lib.mkForce 11;
  };

  system.stateVersion = "26.05";

  networking.hostName = "Akan";
  networking.networkmanager.enable = true;

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

  services = {
    automatic-timezoned.enable = true;
    fprintd.tod.enable = lib.mkForce false;
  };
}
