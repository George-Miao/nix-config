{ pkgs, ... }:
{
  # Wayland Clipboard
  home.packages = with pkgs; [
    wl-clipboard
  ];

  # Clipboard history manager
  services.cliphist.enable = true;

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
        "show-actions" = true;
        "terminal" = "alacritty -e";
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

  # Keybind for wayland
  wayland.windowManager.hyprland.settings.bind = [
    "$mod, v, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
  ];
}
