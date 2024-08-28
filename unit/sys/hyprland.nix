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
    NIXOS_OZONE_WL = "1";
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

    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
      ];
      settings = with builtins; {
        "$mod" = "SUPER";
        xwayland = {
          force_zero_scaling = true;
        };
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
            "CTRL, W, killactive"
            "ALT, space, exec, fuzzel"
            "$mod, return, exec, alacritty"
            "$mod, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
            "$mod, F, togglefloating"
            "$mod, Y, setfloating"
            "$mod, Y, resizeactive, exact 50% 50%"
            "$mod, Y, moveactive, exact 25% 25%"
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            concatLists (genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    toString (x + 1 - (c * 10));
                in [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod shift, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );

        plugins = [
        ];
      };
    };
  };
}
