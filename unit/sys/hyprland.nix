input @ {
  pkgs,
  flake,
  modulesPath,
  specialArgs,
  ...
}: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      };
    };
  };

  environment.variables = {
    # Without this, cursor will be invisible
    WLR_NO_HARDWARE_CURSORS = "1";

    # Electron apps, VSCode in particular, need this to run smoothly on Wayland
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # Hint apps to use wayland
    # NIXOS_OZONE_WL = "1";
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

  home-manager.users.${flake.config.user} = {
    imports = [
      flake.self.unit.home.waybar
      flake.self.unit.home.fuzzel
    ];

    home = {
      packages = with pkgs; [
        qt6.qtwayland
        libsForQt5.qt5.qtwayland
        xdg-desktop-portal-wlr
        grim
        slurp
        wl-clipboard
      ];

      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 14;
      };
    };

    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-margin-top = 0;
        control-center-margin-bottom = 0;
        control-center-margin-right = 0;
        control-center-margin-left = 0;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;

      settings = with builtins;
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        let
          workspace_bind = concatLists (genList (
              x: let
                str = toString (x + 1);
              in [
                "$mod, ${str}, workspace, ${str}"
                "$mod shift, ${str}, movetoworkspace, ${str}"
              ]
            )
            9);
        in {
          "$mod" = "SUPER";
          general = {
            allow_tearing = true;
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
          windowrulev2 = [
            "opacity 0.9 0.9, class:^(Alacritty)$"
            "immediate, class:.*"
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
          bind =
            [
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
          plugins = [
          ];
        };
    };
  };
}
