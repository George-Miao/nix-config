{...}: {
  services.picom = {
    enable = true;

    backend = "glx";
    vSync = true;

    shadow = true;
    shadowOffsets = [(-7) (-7)];
    shadowExclude = [
      "! name~=''"
      "window_type = 'popup_menu'"
      "name = 'Notification'"
      "name = 'Plank'"
      "name = 'Docky'"
      "name = 'Kupfer'"
      "name = 'xfce4-notifyd'"
      "name *= 'VLC'"
      "name = 'cpt_frame_window'"
      "name *= 'compton'"
      "name *= 'picom'"
      "name *= 'Chromium'"
      "name *= 'Chrome'"
      "class_g = 'Firefox' && argb"
      "class_g = 'Conky'"
      "class_g = 'Kupfer'"
      "class_g = 'Synapse'"
      "class_g = 'TelegramDesktop'"
      "class_g ?= 'Notify-osd'"
      "class_g ?= 'Cairo-dock'"
      "class_g ?= 'Xfce4-notifyd'"
      "class_g ?= 'Xfce4-power-manager'"
      "_GTK_FRAME_EXTENTS@:c"
      "WM_WINDOW_ROLE@:s *= 'Popup'"
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
    ];
    opacityRules = [
      "80:class_g = 'Alacritty'"
      "95:class_g = 'Code - Insiders'"
      "80:class_g *?= 'Rofi'"
    ];
    settings = {
      fading = true;
      shadow-radius = 7;
      blur-size = 12;
      blur-deviation = 5.0;
      blur-background = true;
      blur-background-frame = false;
      blur-background-fixed = false;
      blur-kern = "3x3box";
      blur-method = "dual_kawase";
      blur-strength = 20;
      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'popup_menu'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
        "WM_WINDOW_ROLE@:s *= 'Popup'"
        "class_g = 'TelegramDesktop'"
      ];
    };
  };
}
