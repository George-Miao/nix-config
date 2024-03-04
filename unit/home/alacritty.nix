{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      scrolling.multiplier = 3;
      font.normal.family = "Cascadia Code PL";
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };
      window = {
        padding = {
          x = 20;
          y = 20;
        };
      };
    };
  };
}
