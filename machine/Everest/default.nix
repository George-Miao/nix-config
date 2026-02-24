{
  pkgs,
  lib,
  unit,
  consts,
  ...
}:
{
  imports =
    let
      niri = unit.sys.niri {
        display = ''
          output "LG Electronics LG TV SSCR2 0x01010101" {
            mode "3840x2160@119.880"
            scale 1.3
            transform "normal"
            position x=0 y=0
            focus-at-startup
          }
        '';
      };
      scrutiny = unit.sys.scrutiny {
        devices = [
          "/dev/nvme0"
        ];
      };
      vector = unit.sys.vector {
        hostname = "Everest";
        include_units = [
          "home-manager-pop"
          "netbird"
        ];
      };
    in
    with unit.sys;
    [
      globalprotect
      wacom
      logitech
      atd
      sshd
      btrfs
      nvidia
      steam
      obs-studio
      netbird-client
      postgresql
      vscode-server
      virtualbox

      niri
      scrutiny
      vector

      ./hardware.nix
      ./samba.nix
    ];

  home-manager.users.pop = {
    home.packages = with pkgs; [ osu-lazer-bin ];
    programs.alacritty.settings.font.size = lib.mkForce 11;
  };

  system.stateVersion = "24.05";

  networking.hostName = "Everest";

  users.users.pop.openssh.authorizedKeys.keys = [
    consts.ssh
  ];

  boot.loader = {
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

  time.timeZone = "America/New_York";
}
