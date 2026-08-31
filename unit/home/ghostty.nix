{
  lib,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      theme = "everforest-light-soft";
      command = "direct:${pkgs.zellij}/bin/zellij attach --create main";
      font-family = "CaskaydiaCove Nerd Font Mono";
      font-size = 14;
      cursor-style = "block";
      cursor-style-blink = true;
      shell-integration-features = "no-cursor";
      keybind = [
        "ctrl+shift+tab=unbind"
        "ctrl+tab=unbind"
        "super+digit_1=unbind"
        "super+1=unbind"
        "super+digit_2=unbind"
        "super+2=unbind"
        "super+digit_3=unbind"
        "super+3=unbind"
        "super+digit_4=unbind"
        "super+4=unbind"
        "super+digit_5=unbind"
        "super+5=unbind"
        "super+digit_6=unbind"
        "super+6=unbind"
        "super+digit_7=unbind"
        "super+7=unbind"
        "super+digit_8=unbind"
        "super+8=unbind"
        "super+9=unbind"
        "super+alt+w=unbind"
        "super+t=unbind"
        "super+shift+t=unbind"
        "super+shift+arrow_up=unbind"
        "super+shift+arrow_down=unbind"
        "super+shift+[=unbind"
        "super+shift+]=unbind"
        "alt+arrow_left=unbind"
        "alt+arrow_right=unbind"
        "super+alt+arrow_left=unbind"
        "super+alt+arrow_right=unbind"
        "super+alt+arrow_up=unbind"
        "super+alt+arrow_down=unbind"
      ];
      mouse-scroll-multiplier = 3;
      title = "Ghostty";
      window-padding-x = 10;
      window-padding-y = 10;
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      macos-option-as-alt = true;
      macos-window-buttons = "hidden";
    };
    themes.everforest-light-soft = {
      background = "f3ead3";
      foreground = "5c6a72";
      palette = [
        "0=#5c6a72"
        "1=#f85552"
        "2=#8da101"
        "3=#dfa000"
        "4=#3a94c5"
        "5=#df69ba"
        "6=#35a77c"
        "7=#d8d3ba"
        "8=#5c6a72"
        "9=#f85552"
        "10=#8da101"
        "11=#dfa000"
        "12=#3a94c5"
        "13=#df69ba"
        "14=#35a77c"
        "15=#d8d3ba"
      ];
      selection-background = "e1e4bd";
      selection-foreground = "5c6a72";
      search-background = "8da101";
      search-foreground = "f3ead3";
      search-selected-background = "f85552";
      search-selected-foreground = "f3ead3";
    };
  };
}
