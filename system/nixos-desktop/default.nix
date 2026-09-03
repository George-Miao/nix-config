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
    systemPackages = with pkgs; [
      (import ../../lib/mk-apply.nix {
        inherit pkgs;
        name = "rb";
        rebuildCommand = "nixos-rebuild switch";
      })
      gnome-calendar
      gnome-control-center
      gnome-online-accounts-gtk
    ];
  };

  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.evolution-data-server.enable = true;

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
