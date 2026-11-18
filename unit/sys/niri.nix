{
  battery ? false,
  bluetooth ? false,
  brightness ? false,
  display ? [ ],
  extraKeybinds ? [ ],
  gestureSwipeFingers ? null,
  gaps ? 10,
  radius ? 10,
  swapCaps ? false,
  threeFingerDrag ? false,
  ...
}:
{
  pkgs,
  config,
  unit,
  lib,
  inputs,
  ...
}:
let
  kdl = inputs.nix-kdl.kdl;
  cursorName = "BreezeX-Light";
  cursorSize = 24;
  niri = pkgs.niri.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../../patch/niri/three-finger-drag.patch
    ];
  });
in
{
  programs.niri = {
    enable = true;
    package = niri;
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
        Exec=${niri}/bin/niri-session
        Type=Application
        DesktopNames=Niri
      '';
    };
  };

  home-manager.users.pop = {
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      package = pkgs.breezex-cursor;
      name = cursorName;
      size = cursorSize;
    };

    imports = with unit.home; [
      (waybar-niri {
        inherit
          battery
          bluetooth
          brightness
          ;
      })
      fuzzel
      swaync
      wpaperd
    ];

    home.packages = with pkgs; [
      qt6.qtwayland
      qt5.qtwayland
      grim
      slurp
      wl-clipboard
      xwayland-satellite
    ];

    programs.zsh.shellAliases = with pkgs; {
      copy = "${wl-clipboard}/bin/wl-copy";
      paste = "${wl-clipboard}/bin/wl-paste";
    };

    xdg.configFile.niri = {
      target = "niri/config.kdl";
      text =
        with kdl.dsl;
        kdl.formats.v1 (
          [
            (n "debug" [
              (n "emulate-zero-presentation-time")
            ])
            (n "cursor" [
              (n "xcursor-theme" cursorName)
              (n "xcursor-size" cursorSize)
            ])
            (n "input" (
              [
                (n "keyboard" [
                  (n "xkb" (
                    [
                      (n "layout" "us")
                    ]
                    ++ lib.optional swapCaps (n "options" "ctrl:swapcaps")
                  ))
                  (n "repeat-delay" 200)
                  (n "repeat-rate" 50)
                ])
                (n "touchpad" (
                  [
                    (n "tap")
                    (n "natural-scroll")
                    (n "accel-profile" "adaptive")
                    (n "scroll-factor" 0.5)
                    (n "drag" false)
                  ]
                  ++ lib.optional threeFingerDrag (n "three-finger-drag" "3fg")
                  ++ [
                    (n "dwt")
                    (n "dwtp")
                  ]
                ))
              ]
              ++ lib.optional (gestureSwipeFingers != null) (n "gesture-swipe-fingers" gestureSwipeFingers)
              ++ [
                (n "warp-mouse-to-focus")
                (n "focus-follows-mouse")
              ]
            ))
            (n "layout" [
              (n "gaps" gaps)
              (n "center-focused-column" "never")
              (n "preset-column-widths" [
                (n "proportion" 0.33333)
                (n "proportion" 0.5)
                (n "proportion" 0.66667)
              ])
              (n "preset-window-heights" [
                (n "proportion" 0.5)
                (n "proportion" 1.0)
              ])
              (n "default-column-width" [
                (n "proportion" 0.66667)
              ])
              (n "focus-ring" [
                (n "width" 2)
                (n "active-color" "#ffebe1ff")
                (n "inactive-color" "#505050")
              ])
              (n "border" [
                (n "off")
              ])
            ])
            (n "blur" [
              (n "passes" 3)
              (n "offset" 5)
              (n "noise" 0.02)
              (n "saturation" 1)
            ])
            (n "prefer-no-csd")
            (n "screenshot-path" "~/Pictures/Screenshots/Screenshot-%Y-%m-%d %H-%M-%S.png")
            (n "window-rule" [
              (n "geometry-corner-radius" radius)
              (n "clip-to-geometry" true)
            ])
            (n "window-rule" [
              (n "match" {
                app-id = "^zen";
                title = "^Extension:";
              })
              (n "open-floating" true)
              (n "min-width" 350)
              (n "max-width" 350)
              (n "min-height" 700)
              (n "max-height" 700)
            ])
            (n "window-rule" [
              (n "match" { app-id = "^zen"; })
              (n "exclude" { title = "^Extension:"; })
              (n "default-column-width" [
                (n "proportion" 0.33333)
              ])
            ])
            (n "window-rule" [
              (n "match" {
                app-id = "^zen";
                title = "^Picture-in-Picture$";
              })
              (n "open-floating" true)
              (n "default-column-width" [
                (n "fixed" 480)
              ])
              (n "default-window-height" [
                (n "fixed" 270)
              ])
            ])
            (n "window-rule" [
              (n "match" { app-id = "^[Ww]aydroid"; })
              # Waydroid requests maximized-to-edges mode at startup.
              (n "open-maximized-to-edges" false)
              (n "default-column-width" [
                (n "proportion" 0.33333)
              ])
            ])
            (n "window-rule" [
              (n "match" { app-id = "^waydroid[.]eu[.]kanade[.]tachiyomi([.]|$)"; })
              (n "default-column-width" [
                (n "proportion" 0.66667)
              ])
            ])
            (n "window-rule" [
              (n "match" { title = "(?i)^rotatrix$"; })
              (n "open-floating" true)
              (n "default-floating-position" {
                x = 10;
                y = 10;
                relative-to = "bottom-right";
              })
            ])
            (n "window-rule" [
              (n "match" { app-id = "^Alacritty$"; })
              (n "background-effect" [
                (n "blur" true)
              ])
              (n "opacity" 0.95)
              (n "default-column-width" [
                (n "proportion" 0.33333)
              ])
              (n "default-window-height" [
                (n "proportion" 0.5)
              ])
            ])
            (n "binds" (
              extraKeybinds
              ++ [
                (n "Mod+Shift+Slash" [
                  (n "show-hotkey-overlay")
                ])
                (n "Mod+Return" { hotkey-overlay-title = "Open a Terminal: Ghostty"; } [
                  (n "spawn" "ghostty")
                ])
                (n "Alt+Space" { hotkey-overlay-title = "Run an Application: fuzzel"; } [
                  (n "spawn" "fuzzel")
                ])
                (n "Mod+V" { hotkey-overlay-title = "Open Clipboard Manager"; } [
                  (n "spawn-sh" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy")
                ])
                (n "Mod+S" { hotkey-overlay-title = "Take a Screenshot of the selected area"; } [
                  (n "spawn-sh" ''grim -g "$(slurp -d)" - | wl-copy'')
                ])
                (n "XF86AudioRaiseVolume" { allow-when-locked = true; } [
                  (n "spawn" "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+")
                ])
                (n "XF86AudioLowerVolume" { allow-when-locked = true; } [
                  (n "spawn" "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-")
                ])
                (n "XF86AudioMute" { allow-when-locked = true; } [
                  (n "spawn" "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle")
                ])
                (n "XF86AudioMicMute" { allow-when-locked = true; } [
                  (n "spawn" "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle")
                ])
                # Open/close the Overview: a zoomed-out view of workspaces and windows.
                # The top-left hot corner and a four-finger swipe up also open it.
                (n "Mod+O" { repeat = false; } [
                  (n "toggle-overview")
                ])
                (n "Mod+Y" [
                  (n "spawn-sh" ''
                    niri msg action move-window-to-floating &&
                    sleep 0.1 &&
                    niri msg action set-window-height 70% &&
                    sleep 0.1 &&
                    niri msg action set-window-width 60% &&
                    sleep 0.1 &&
                    niri msg action center-window
                  '')
                ])
                (n "Ctrl+Q" [ (n "close-window") ])
                (n "Mod+Left" [ (n "focus-column-left") ])
                (n "Mod+Down" [ (n "focus-window-or-workspace-down") ])
                (n "Mod+Up" [ (n "focus-window-or-workspace-up") ])
                (n "Mod+Right" [ (n "focus-column-right") ])
                (n "Mod+Shift+Left" [ (n "move-column-left") ])
                (n "Mod+Shift+Right" [ (n "move-column-right") ])
                (n "Mod+Shift+Down" [ (n "move-window-down-or-to-workspace-down") ])
                (n "Mod+Shift+Up" [ (n "move-window-up-or-to-workspace-up") ])
                (n "Mod+Ctrl+Left" [ (n "focus-column-first") ])
                (n "Mod+Ctrl+Right" [ (n "focus-column-last") ])
                (n "Mod+Ctrl+Shift+Left" [ (n "move-column-to-first") ])
                (n "Mod+Ctrl+Shift+Right" [ (n "move-column-to-last") ])
                (n "Mod+U" [ (n "focus-workspace-down") ])
                (n "Mod+I" [ (n "focus-workspace-up") ])
                (n "Mod+Ctrl+U" [ (n "move-column-to-workspace-down") ])
                (n "Mod+Ctrl+I" [ (n "move-column-to-workspace-up") ])
                (n "Mod+Shift+U" [ (n "move-workspace-down") ])
                (n "Mod+Shift+I" [ (n "move-workspace-up") ])
                (n "Mod+WheelScrollDown" { cooldown-ms = 150; } [ (n "focus-workspace-down") ])
                (n "Mod+WheelScrollUp" { cooldown-ms = 150; } [ (n "focus-workspace-up") ])
                (n "Mod+Ctrl+WheelScrollDown" { cooldown-ms = 150; } [ (n "move-column-to-workspace-down") ])
                (n "Mod+Ctrl+WheelScrollUp" { cooldown-ms = 150; } [ (n "move-column-to-workspace-up") ])
                (n "Mod+WheelScrollRight" [ (n "focus-column-right") ])
                (n "Mod+WheelScrollLeft" [ (n "focus-column-left") ])
                (n "Mod+Ctrl+WheelScrollRight" [ (n "move-column-right") ])
                (n "Mod+Ctrl+WheelScrollLeft" [ (n "move-column-left") ])
                (n "Mod+1" [ (n "focus-workspace" 1) ])
                (n "Mod+2" [ (n "focus-workspace" 2) ])
                (n "Mod+3" [ (n "focus-workspace" 3) ])
                (n "Mod+4" [ (n "focus-workspace" 4) ])
                (n "Mod+5" [ (n "focus-workspace" 5) ])
                (n "Mod+6" [ (n "focus-workspace" 6) ])
                (n "Mod+7" [ (n "focus-workspace" 7) ])
                (n "Mod+8" [ (n "focus-workspace" 8) ])
                (n "Mod+9" [ (n "focus-workspace" 9) ])
                (n "Mod+Shift+1" [ (n "move-column-to-workspace" 1) ])
                (n "Mod+Shift+2" [ (n "move-column-to-workspace" 2) ])
                (n "Mod+Shift+3" [ (n "move-column-to-workspace" 3) ])
                (n "Mod+Shift+4" [ (n "move-column-to-workspace" 4) ])
                (n "Mod+Shift+5" [ (n "move-column-to-workspace" 5) ])
                (n "Mod+Shift+6" [ (n "move-column-to-workspace" 6) ])
                (n "Mod+Shift+7" [ (n "move-column-to-workspace" 7) ])
                (n "Mod+Shift+8" [ (n "move-column-to-workspace" 8) ])
                (n "Mod+Shift+9" [ (n "move-column-to-workspace" 9) ])
                (n "Mod+BracketLeft" [ (n "consume-or-expel-window-left") ])
                (n "Mod+BracketRight" [ (n "consume-or-expel-window-right") ])
                (n "Mod+Comma" [ (n "consume-window-into-column") ])
                (n "Mod+Period" [ (n "expel-window-from-column") ])
                (n "Mod+R" [ (n "switch-preset-column-width") ])
                (n "Mod+Shift+R" [ (n "switch-preset-window-height") ])
                (n "Mod+Ctrl+R" [ (n "reset-window-height") ])
                (n "Mod+F" [ (n "toggle-window-floating") ])
                (n "Alt+Ctrl+F" [ (n "expand-column-to-available-width") ])
                (n "Alt+Shift+F" [ (n "fullscreen-window") ])
                (n "Mod+C" [ (n "center-column") ])
                # Center all fully visible columns on screen.
                (n "Mod+Ctrl+C" [ (n "center-visible-columns") ])
                (n "Mod+Minus" [ (n "set-column-width" "-10%") ])
                (n "Mod+Equal" [ (n "set-column-width" "+10%") ])
                # Finer height adjustments when in a column with other windows.
                (n "Mod+Shift+Minus" [ (n "set-window-height" "-10%") ])
                (n "Mod+Shift+Equal" [ (n "set-window-height" "+10%") ])
                (n "Mod+Shift+V" [ (n "switch-focus-between-floating-and-tiling") ])
                (n "Mod+Shift+S" [ (n "screenshot-window") ])
                # Remote-desktop clients and KVM switches may inhibit shortcuts.
                # Keep an escape hatch that works even while an inhibitor is active.
                (n "Mod+Escape" { allow-inhibiting = false; } [
                  (n "toggle-keyboard-shortcuts-inhibit")
                ])
                # Quit shows a confirmation dialog to avoid accidental exits.
                (n "Mod+Shift+E" [ (n "quit") ])
                (n "Ctrl+Alt+Delete" [ (n "quit") ])
                # Any input, such as moving the mouse, turns the monitors back on.
                (n "Mod+Shift+P" [ (n "power-off-monitors") ])
              ]
            ))
          ]
          ++ display
        );
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
