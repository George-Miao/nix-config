{
  pkgs,
  unit,
  ...
}:
{
  imports = with unit.sys; [
    ../shared
    ../shared/nixos.nix
    ./fonts.nix
    ./xdg.nix

    ratbag
    fwupd
    adb
    spacenav
    probe-rs
    flipper
    printer
    docker
    pipewire
    keyring
    kdeconnect
  ];

  environment = {
    systemPackages = [
      (import ../../lib/mk-apply.nix {
        inherit pkgs;
        name = "rb";
        rebuildCommand = "nixos-rebuild switch";
      })
    ];
  };

  home-manager.users.pop = {
    imports = with unit; [
      preset.local
      preset.gui
      home.dropbox
    ];

    home = {
      packages = with pkgs; [
        nautilus
        pciutils
        glibc
        plex-desktop
        usbutils
        grub2
        evince
        gnome-clocks
        eog
        gnome-2048
      ];
    };
    programs.zsh.shellAliases = {
      "open" = "setsid xdg-open";
    };
  };
}
