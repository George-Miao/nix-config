{ pkgs, ... }:
let
  theme = pkgs.fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "02ed0a1826d008885c0cd4589c9eff892773a62a";
    hash = "sha256-ljTdsfd/bClvnr2DlndEreNuLZ705wo+XSCvkUBVw8Y=";
  };
in
{
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "${theme}/themes/everforest_light_soft.toml"
      ];
      # colors = nordic;
      scrolling.multiplier = 3;
      font = {
        normal.family = "CaskaydiaCove Nerd Font Mono";
        size = 14;
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };
      window = {
        option_as_alt = "Both";
        dynamic_title = false;
        decorations = "Transparent";
        padding = {
          x = 10;
          y = 10;
        };
      };
      keyboard.bindings = [
        {
          key = "C";
          mods = "Command";
          chars = "\\u0003";
        }
        {
          key = "C";
          mods = "Command | Shift";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Command | Shift";
          action = "Paste";
        }
      ];
    };
  };
  programs.zsh = {
    initContent = ''
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
      bindkey "^[[1;9C" end-of-line
      bindkey "^[[1;9D" beginning-of-line
    '';
  };
}
