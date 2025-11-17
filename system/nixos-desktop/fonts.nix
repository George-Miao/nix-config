{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = import ../shared/font-pkgs.nix { inherit pkgs; };

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Cascadia Code"
          "Caskaydia Cove"
        ];
        sansSerif = [
          "Noto Sans"
          "Source Han Sans SC"
        ];
        serif = [
          "Noto Serif"
          "Source Han Serif SC"
        ];
      };
    };
  };
}
