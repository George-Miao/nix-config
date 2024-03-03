{ lib, ... }: {
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      terminal = "alacritty";
      modifier = "Mod4";
      gaps = { inner = 10; };
      keybindings = lib.mkOptionDefault {
        "Mod1+f4" = "kill";
        "Ctrl+q" = "kill";
        "Mod1+space" = "exec rofi -show combi";
      };
      window = {
        titlebar = false;
        border = 0;
      };
    };
  };
}
