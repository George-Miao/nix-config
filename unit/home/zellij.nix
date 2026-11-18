{
  inputs,
  pkgs,
  ...
}:
let
  kdl = inputs.nix-kdl.kdl;
  swapSuperCtrl =
    key:
    if builtins.match "Super .*" key != null then
      builtins.replaceStrings [ "Super" ] [ "Ctrl" ] key
    else
      null;
  bind =
    key: actions:
    let
      ctrlKey = swapSuperCtrl key;
      keys = [ key ] ++ (if ctrlKey == null then [ ] else [ ctrlKey ]);
    in
    builtins.map (key: kdl.dsl.n "bind" key actions) keys;
  nodes = with kdl.dsl; [
    (n "plugins" [
      (n "about" { location = "zellij:about"; })
      (n "compact-bar" { location = "zellij:compact-bar"; })
      (n "configuration" { location = "zellij:configuration"; })
      (n "filepicker" { location = "zellij:strider"; } [
        (n "cwd" "/")
      ])
      (n "plugin-manager" { location = "zellij:plugin-manager"; })
      (n "session-manager" { location = "zellij:session-manager"; })
      (n "status-bar" { location = "zellij:status-bar"; })
      (n "strider" { location = "zellij:strider"; })
      (n "tab-bar" { location = "zellij:tab-bar"; })
      (n "welcome-screen" { location = "zellij:session-manager"; } [
        (n "welcome_screen" true)
      ])
    ])
    # Plugins to load in the background when a new session starts.
    (n "load_plugins" [
      (n "zellij:link")
    ])
    (n "theme" "everforest-light")
    (n "default_layout" "compact")
    (n "pane_frames" false)
    (n "show_startup_tips" false)
    (n "support_kitty_keyboard_protocol" true)
    (n "web_client" [
      (n "font" "monospace")
    ])
    (n "keybinds" { clear-defaults = true; } [
      (n "shared_except" "locked" (
        (bind "Super Alt left" [ (n "MoveFocusOrTab" "left") ])
        ++ (bind "Super Alt down" [ (n "MoveFocus" "down") ])
        ++ (bind "Super Alt up" [ (n "MoveFocus" "up") ])
        ++ (bind "Super Alt right" [ (n "MoveFocusOrTab" "right") ])
        ++ (bind "Super Shift left" [ (n "NewPane" "left") ])
        ++ (bind "Super Shift down" [ (n "NewPane" "down") ])
        ++ (bind "Super Shift up" [ (n "NewPane" "up") ])
        ++ (bind "Super Shift right" [ (n "NewPane" "right") ])
        ++ (bind "Super l" [ (n "SwitchToMode" "locked") ])
        ++ (bind "Super Alt Shift left" [ (n "NewPane" "left") ])
        ++ (bind "Super Alt Shift down" [ (n "NewPane" "down") ])
        ++ (bind "Super Alt Shift up" [ (n "NewPane" "up") ])
        ++ (bind "Super Alt Shift right" [ (n "NewPane" "right") ])
        ++ (bind "Super Shift Backspace" [ (n "CloseFocus") ])
        ++ (bind "Super Shift [" [ (n "GoToPreviousTab") ])
        ++ (bind "Super Shift ]" [ (n "GoToNextTab") ])
        ++ (bind "Super Shift t" [ (n "NewTab") ])
        ++ [
          (n "bind" "Alt Shift left" [ (n "NewPane" "left") ])
          (n "bind" "Alt Shift down" [ (n "NewPane" "down") ])
          (n "bind" "Alt Shift up" [ (n "NewPane" "up") ])
          (n "bind" "Alt Shift right" [ (n "NewPane" "right") ])
          (n "bind" "Alt -" [ (n "Resize" "Decrease") ])
          (n "bind" "Alt +" [ (n "Resize" "Increase") ])
          (n "bind" "Alt =" [ (n "Resize" "Increase") ])
          (n "bind" "Alt [" [ (n "PreviousSwapLayout") ])
          (n "bind" "Alt ]" [ (n "NextSwapLayout") ])
          (n "bind" "Alt 1" [ (n "GoToTab" 1) ])
          (n "bind" "Alt 2" [ (n "GoToTab" 2) ])
          (n "bind" "Alt 3" [ (n "GoToTab" 3) ])
          (n "bind" "Alt 4" [ (n "GoToTab" 4) ])
          (n "bind" "Alt 5" [ (n "GoToTab" 5) ])
          (n "bind" "Alt 6" [ (n "GoToTab" 6) ])
          (n "bind" "Alt 7" [ (n "GoToTab" 7) ])
          (n "bind" "Alt 8" [ (n "GoToTab" 8) ])
          (n "bind" "Alt 9" [ (n "GoToTab" 9) ])
          (n "bind" "Alt 0" [ (n "GoToTab" 10) ])
          (n "bind" "Alt f" [ (n "ToggleFloatingPanes") ])
        ]
      ))
      (n "shared_except" "normal" "locked" [
        (n "bind" "esc" [ (n "SwitchToMode" "normal") ])
        (n "bind" "enter" [ (n "SwitchToMode" "normal") ])
      ])
      (n "shared_except" "locked" "session" [
        (n "bind" "Super o" [ (n "SwitchToMode" "session") ])
      ])
      (n "shared_except" "locked" "scroll" (bind "Super s" [ (n "SwitchToMode" "scroll") ]))
      (n "shared_among" "scroll" [
        (n "bind" "up" [ (n "ScrollUp") ])
        (n "bind" "down" [ (n "ScrollDown") ])
        (n "bind" "left" [ (n "PageScrollUp") ])
        (n "bind" "right" [ (n "PageScrollDown") ])
        (n "bind" "Alt up" [ (n "HalfPageScrollUp") ])
        (n "bind" "Alt down" [ (n "HalfPageScrollDown") ])
      ])
      (n "locked" (bind "Super l" [ (n "SwitchToMode" "normal") ]))
      (n "scroll" [
        (n "bind" "e" [
          (n "EditScrollback")
          (n "SwitchToMode" "normal")
        ])
      ])
      (n "session" [
        (n "bind" "Super o" [ (n "SwitchToMode" "normal") ])
        (n "bind" "a" [
          (n "LaunchOrFocusPlugin" "zellij:about" [
            (n "floating" true)
            (n "move_to_focused_tab" true)
          ])
          (n "SwitchToMode" "normal")
        ])
        (n "bind" "l" [
          (n "LaunchOrFocusPlugin" "zellij:layout-manager" [
            (n "floating" true)
            (n "move_to_focused_tab" true)
          ])
          (n "SwitchToMode" "normal")
        ])
        (n "bind" "p" [
          (n "LaunchOrFocusPlugin" "plugin-manager" [
            (n "floating" true)
            (n "move_to_focused_tab" true)
          ])
          (n "SwitchToMode" "normal")
        ])
        (n "bind" "s" [
          (n "LaunchOrFocusPlugin" "zellij:share" [
            (n "floating" true)
            (n "move_to_focused_tab" true)
          ])
          (n "SwitchToMode" "normal")
        ])
        (n "bind" "w" [
          (n "LaunchOrFocusPlugin" "session-manager" [
            (n "floating" true)
            (n "move_to_focused_tab" true)
          ])
          (n "SwitchToMode" "normal")
        ])
      ])
    ])
  ];
in
{
  home.packages = [ pkgs.zellij ];

  xdg.configFile.zellij = {
    recursive = true;
    target = "zellij/config.kdl";
    text = kdl.formats.v1 nodes;
  };
}
