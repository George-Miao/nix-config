{
  pkgs,
  lib,
  unit,
  ...
}:
let
  delayed_services = [
    "swaync"
    "waybar"
    "wpaperd"
    "cliphist"
    "cliphist-images"
  ];
  systemd_delay = with builtins; {
    systemd.user.services = listToAttrs (
      map (service: {
        name = service;
        value = {
          Service.RestartSec = lib.mkForce 2;
        };
      }) delayed_services
    );
  };
in
{
  programs.hyprland.enable = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  environment = {
    variables = {
      # Without this, cursor will be invisible
      WLR_NO_HARDWARE_CURSORS = "1";

      # Electron apps, VSCode in particular, need this to run smoothly on Wayland
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      # Enable Wayland IME support in Electron apps
      ELECTRON_ENABLE_WAYLAND_IME = "1";

      HYPRLAND_NO_SD_NOTIFY = 1;

      # Hint apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      # bibata-cursors
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd Hyprland";
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
    config.Hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
    };
    extraPortals = [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  home-manager.users.pop = {
    imports = with unit.home; [
      waybar-hyprland
      fuzzel
      swaync
    ];

    home = {
      packages = with pkgs; [
        qt6.qtwayland
        libsForQt5.qt5.qtwayland
        grim
        slurp
        wl-clipboard
      ];

      # pointerCursor = {
      #   gtk.enable = true;
      #   package = pkgs.bibata-cursors;
      #   name = "Bibata Modern Ice";
      #   size = 24;
      # };
    };

    wayland.windowManager.hyprland = {
      enable = true;

      systemd.extraCommands = [
        "systemctl --user restart hyprland-session.target"
      ];

      settings =
        with builtins;
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        let
          workspace_bind = concatLists (
            genList (
              x:
              let
                str = toString (x + 1);
              in
              [
                "$mod, ${str}, workspace, ${str}"
                "$mod shift, ${str}, movetoworkspace, ${str}"
              ]
            ) 9
          );
        in
        {
          "$mod" = "SUPER";
          general = {
            allow_tearing = true;
          };
          debug.disable_logs = false;
          misc = {
            vrr = 2;
          };
          xwayland = {
            force_zero_scaling = true;
          };
          decoration = {
            blur = {
              enabled = true;
              size = 20;
              passes = 3;
              new_optimizations = "on";
            };
          };
          master = {
            mfact = 0.75;
            allow_small_split = true;
          };
          windowrulev2 = [
            "opacity 0.9 0.9, class:^(Alacritty)$"
            # "immediate, class:.*"
            "float, class:^(zen-twilight)$, title:^Extension.*$"
          ];
          input = {
            sensitivity = -0.6;
            repeat_delay = 200;
            repeat_rate = 50;
          };
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          bind = [
            "CTRL, Q, killactive"
            "ALT, space, exec, fuzzel"
            "$mod, return, exec, alacritty"
            "$mod, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
            "$mod, F, togglefloating"
            "$mod, Y, setfloating"
            "$mod, Y, resizeactive, exact 60% 60%"
            "$mod, Y, centerwindow"
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
          ]
          ++ workspace_bind;
          env = [
            "WLR_DRM_NO_ATOMIC,1"
            # "HYPRCURSOR_SIZE,24"
            # "XCURSOR_SIZE,24"
            # "HYPRCURSOR_THEME,Bibata-Modern-Ice"
            # "XCURSOR_THEME,Bibata-Modern-Ice"
          ];
          exec-once = [
            # "hyprctl setcursor Bibata-Modern-Ice 24"
          ];
        };
    };
  }
  // systemd_delay;
}
