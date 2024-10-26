{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      ubuntu_font_family
      corefonts
      vistafonts
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      liberation_ttf
      font-awesome
      powerline-fonts
      mplus-outline-fonts.githubRelease
      (nerdfonts.override {fonts = ["Noto"];})
    ];

    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Cascadia Code"];
        sansSerif = ["Noto Sans" "Source Han Sans SC"];
        serif = ["Noto Serif" "Source Han Serif SC"];
      };
    };
  };
}
