{...}: let
  ayu_dark = builtins.fromTOML ''
    # Default colors
    [primary]
    background = '#0A0E14'
    foreground = '#B3B1AD'

    # Normal colors
    [normal]
    black   = '#01060E'
    red     = '#EA6C73'
    green   = '#91B362'
    yellow  = '#F9AF4F'
    blue    = '#53BDFA'
    magenta = '#FAE994'
    cyan    = '#90E1C6'
    white   = '#C7C7C7'

    # Bright colors
    [bright]
    black   = '#686868'
    red     = '#F07178'
    green   = '#C2D94C'
    yellow  = '#FFB454'
    blue    = '#59C2FF'
    magenta = '#FFEE99'
    cyan    = '#95E6CB'
    white   = '#FFFFFF'
  '';
  nordic = builtins.fromTOML ''
    [primary]
    background = '#242933'
    foreground = '#BBBDAF'

    [normal]
    black = '#191C1D'
    red = '#BD6062'
    green = '#A3D6A9'
    yellow = '#F0DFAF'
    blue = '#8FB4D8'
    magenta = '#C7A9D9'
    cyan = '#B6D7A8'
    white = '#BDC5BD'

    [bright]
    black = '#727C7C'
    red = '#D18FAF'
    green = '#B7CEB0'
    yellow = '#BCBCBC'
    blue = '#E0CF9F'
    magenta = '#C7A9D9'
    cyan = '#BBDA97'
    white = '#BDC5BD'

    [selection]
    text = '#000000'
    background = '#F0DFAF'
  '';
in {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = nordic;
      scrolling.multiplier = 3;
      font = {
        normal.family = "Cascadia Code PL";
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
    };
  };
}
