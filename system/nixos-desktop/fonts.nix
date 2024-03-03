{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    cascadia-code
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  fonts.fontDir.enable = true;
}
