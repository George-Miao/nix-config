{display ? "", ...}: {
  pkgs,
  flake,
  lib,
  ...
}: {
  programs.niri.enable = true;

  home-manager.users.${flake.config.user} = {
    imports = with flake.self.unit.home; [
      waybar-niri
      fuzzel
      swaync
      wpaperd
    ];

    home.packages = with pkgs; [
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
      grim
      slurp
      wl-clipboard
      xwayland-satellite
    ];

    xdg.configFile.niri = let
      base = builtins.readFile ./niri.config.kdl;
    in {
      recursive = true;
      target = "niri/config.kdl";
      text = ''
        ${base}
        ${display}
      '';
    };
  };

  environment = {
    variables = {
      # Without this, cursor will be invisible
      WLR_NO_HARDWARE_CURSORS = "1";

      # Electron apps, VSCode in particular, need this to run smoothly on Wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      # Enable Wayland IME support in Electron apps
      ELECTRON_ENABLE_WAYLAND_IME = "1";

      HYPRLAND_NO_SD_NOTIFY = 1;

      # Hint apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  systemd.user.services.niri.wants = [
    "waybar.service"
    "swaync.service"
    "wpaperd.service"
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd niri-session";
        user = flake.config.user;
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";

    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  security = {
    polkit.enable = true;
  };

  xdg.portal = with pkgs; {
    enable = true;
    extraPortals = [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };
}
