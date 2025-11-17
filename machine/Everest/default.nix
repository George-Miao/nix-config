{
  flake,
  consts,
  lib,
  pkgs,
  ...
}:
{
  imports = with flake.self.unit.sys; [
    flake.self.nixosModules.desktop

    logitech
    atd
    sshd
    btrfs
    amdgpu
    steam
    obs-studio
    netbird-client
    postgresql
    vscode-server
    virtualbox

    (niri {
      display = ''
        output "LG Electronics LG TV SSCR2 0x01010101" {
          mode "3840x2160@60"
          scale 1.3
          transform "normal"
          position x=1920 y=0
          focus-at-startup
        }
        output "ASUSTek COMPUTER INC VG279QM M6LMQS104605" {
          mode "1920x1080@239.760"
          position x=0 y=0
        }
      '';
    })
    # hyprland
    # (tailscale {autoStart = true;})
    (scrutiny {
      devices = [
        "/dev/nvme0"
        "/dev/nvme1"
      ];
    })
    (vector {
      hostname = "Everest";
      include_units = [
        "home-manager-pop"
        "netbird"
      ];
    })

    ./hardware.nix
    ./samba.nix
  ];

  environment.systemPackages = [
    pkgs.sbctl
  ];

  home-manager.users.${flake.config.user} = {
    programs.alacritty.settings.font.size = lib.mkForce 11;
    programs.zsh.shellAliases = {
      "win" = "sudo bootctl set-oneshot auto-windows && reboot";
    };
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
    systemd-boot = {
      enable = lib.mkForce false;
      configurationLimit = 3;
      edk2-uefi-shell.enable = true;
    };
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  time.timeZone = "America/New_York";
  # time.timeZone = "Asia/Shanghai";
}
