{
  display ? "",
  ...
}:
{
  pkgs,
  config,
  unit,
  lib,
  ...
}:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri.overrideAttrs (
      final: prev: {
        cargoHash = "sha256-Iaqr19d52MgDkNZyNoE44K7VeZmU8NCp7jpUoaHCYt4=";
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit (final) src;
          name = "${final.pname}-${final.version}";
          hash = final.cargoHash;
        };
        src = pkgs.fetchgit {
          "url" = "https://github.com/niri-wm/niri";
          "rev" = "74d2b18603366b98ec9045ecf4a632422f472365";
          "hash" = "sha256-OGorFif714JwKW/FEIrSJ2i2BsBaiLRd2TPbMq86RTs=";
        };
        postPatch = ''
          patchShebangs resources/niri-session
          substituteInPlace resources/niri.service --replace-fail 'ExecStart=niri' "ExecStart=$out/bin/niri"
        '';
      }
    );
  };

  environment.etc = {
    "wayland-sessions/steam.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Steam
        Comment=Wayland session for Steam
        Exec=${pkgs.gamescope}/bin/gamescope -e -r 240 -- steam -tenfoot -steamos
        Type=Application
        DesktopNames=Steam
      '';
    };
    "wayland-sessions/niri.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Niri
        Comment=Wayland session for Niri
        Exec=${pkgs.niri}/bin/niri-session
        Type=Application
        DesktopNames=Niri
      '';
    };
  };

  home-manager.users.pop = {
    imports = with unit.home; [
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

    programs.zsh.shellAliases = with pkgs; {
      copy = "${wl-clipboard}/bin/wl-copy";
      paste = "${wl-clipboard}/bin/wl-paste";
    };

    xdg.configFile.niri =
      let
        base = builtins.readFile ./niri.config.kdl;
      in
      {
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
      # WLR_NO_HARDWARE_CURSORS = "1";

      # Electron apps, VSCode in particular, need this to run smoothly on Wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      # Enable Wayland IME support in Electron apps
      ELECTRON_ENABLE_WAYLAND_IME = "1";

      # Hint apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.seatd.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = with pkgs; {
        command = "${lib.getExe tuigreet} -t -r -s /etc/wayland-sessions";
        # command = "${lib.getExe tuigreet} --time --remember --cmd '${lib.getExe gamescope} -e -r 240 -- steam -tenfoot'";
        user = "pop";
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
