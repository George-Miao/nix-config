{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      "main" = {
        "inner-pad" = 10;
        "vertical-pad" = 10;
        "horizontal-pad" = 10;
        "width" = 80;
        "line-height" = "40px";
        "icon-theme" = "Adwaita";
      };

      "colors" = {
        "background" = "282a36dd";
        "text" = "f8f8f2ff";
        "match" = "8be9fdff";
        "selection-match" = "8be9fdff";
        "selection" = "44475add";
        "selection-text" = "f8f8f2ff";
        "border" = "bd93f9ff";
      };

      "border" = {
        "width" = 2;
        "radius" = 0;
      };
    };
  };
}
