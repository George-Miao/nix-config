{...}: {
  programs.rofi = {
    enable = true;
    font = "Cascadia Code 12";
    extraConfig = {
      modi = "window,drun,run,ssh,combi";
      show-icons = false;
      terminal = "alacritty";
      separator-style = "solid";
      dpi = 90;
    };
  };
}
