{ pkgs, zellijPackage, ... }:
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
      terminal.shell = {
        program = "${zellijPackage}/bin/zellij";
        args = [
          "attach"
          "--create"
          "main"
        ];
      };
      scrolling.multiplier = 3;
      font = {
        normal.family = "CaskaydiaCove Nerd Font Mono";
        size = 14;
      };
      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
      };
      window = {
        option_as_alt = "Both";
        dynamic_title = false;
        decorations = "Buttonless";
        padding = {
          x = 10;
          y = 10;
        };
      };
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
