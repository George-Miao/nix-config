{
  pkgs,
  unit,
  ...
}:
let
  vncdo = pkgs.python3Packages.vncdotool.overridePythonAttrs (oldAttrs: rec {
    pname = "vncdotool";
    version = "1.4.2";

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-A8RuGiGFSFB3Ipypd1IhKXa91kyzblXotHpUYUjn6bA=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      cryptography
      pillow
      twisted
    ];

    # Functional tests require the vncdo entry point before installation.
    enabledTestPaths = [ "tests/unit" ];

    meta = oldAttrs.meta // {
      changelog = "https://github.com/sibson/vncdotool/releases/tag/v${version}";
    };
  });
in
{
  imports = with unit.sys; [
    ../shared
    ../shared/nixos.nix
    ./fonts.nix
    ./xdg.nix

    ratbag
    fwupd
    adb
    (unit.sys."usb-automount")
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
      vncdo
      pkgs.wayvnc
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
        # Native Wayland falls back to llvmpipe on NVIDIA.
        (plex-desktop.override {
          extraEnv.WAYLAND_DISPLAY = "";
        })
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
