{
  pkgs,
  flake,
  ...
}: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  home-manager.users.${flake.config.user} = {
    home = {
      packages = with pkgs; [
        qt6.qtwayland
        libsForQt5.qt5.qtwayland
      ];

      sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      file.".config/code-flags.conf".text = ''
        {
          "window.titleBarStyle": "custom",
          "editor.smoothScrolling": true
        }
      '';
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = [
        {
          modules-left = ["hyprland/workspaces"];
          modules-center = ["clock#time"];
          modules-right = [
            "clock#date"
            "wlr/taskbar"
            "tray"
            "idle_inhibitor"
            "pulseaudio"
            "pulseaudio/slider"
            "temperature"
          ];
          "hyprland/workspaces" = {
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            "format" = "{icon}";
            "format-icons" = {
              "1" = "1 <span font='Font Awesome 5 Free 11'> </span>";
              "2" = "2 <span font='Font Awesome 5 Free 11'> </span>";
              "3" = "3 <span font='Font Awesome 5 Free 11'> </span>";
              "4" = "4 <span font='Font Awesome 5 Free 11'> </span>";
              "5" = "5 <span font='Font Awesome 5 Free 11'> </span>";
              "6" = "6 <span font='Font Awesome 5 Free 11'> </span>";
            };
          };
          "hyprland/window" = {
            "format" = "👉 {}";
            "separate-outputs" = true;
          };
          "network" = {
            "format" = "{icon}";
            "format-alt" = "{ipaddr}/{cidr} {icon}";
            "format-alt-click" = "click-right";
            "format-wifi" = "<span font='Font Awesome 5 Free 10'></span>  {essid} ({signalStrength}%)";
            "format-ethernet" = " {ifname}";
            "format-disconnected" = "⚠ Disconnected";
            "on-click" = "terminator -e ~/sway/scripts/network-manager";
            "tooltip" = false;
          };
          "pulseaudio" = {
            "format" = "<span font='Font Awesome 5 Free 11'>{icon:2}</span> {volume:4}%";
            "format-muted" = "<span font='Font Awesome 5 Free 11'></span>";
            "format-icons" = {
              "headphone" = [" " " " " " " "];
              "default" = ["" "" "" ""];
            };
            "scroll-step" = 2;
            "on-click" = "pavucontrol";
            "tooltip" = false;
          };
          "clock#time" = {
            format = "{:%H:%M}";
          };
          "clock#date" = {
            format = "{:%a, %b %d}";
          };
        }
      ];
      style = ''
        * {
            font-family: "sans-serif";
            font-size: 13px;
            min-height: 0;
            color: rgb(250, 250, 250);
        }

        window#waybar {
            background: rgba(15, 15, 15, 0.55);

        tooltip {
        	background: rgba(250, 250, 250, 0.4);
        }
        	border-radius: 8px;
        	border-width: 2px;
        	border-style: solid;
          color: white;
        }
      '';
    };

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
      ];
      settings = with builtins; {
        "$mod" = "SUPER";
        input = {
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
            "ALT, space, exec, rofi -show combi"
            "$mod, return, exec, alacritty"
            "$mod, F, togglefloating"
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
