{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      liberation_ttf
      mplus-outline-fonts.githubRelease
    ];

    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Cascadia Code"];
        sansSerif = ["Source Han Sans SC" "DejaVu Sans"];
        serif = ["Source Han Serif SC" "DejaVu Serif"];
      };
    };
  };
}
