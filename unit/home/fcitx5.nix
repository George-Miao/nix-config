{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      libsForQt5.fcitx5-qt
      fcitx5-gtk
      fcitx5-mozc
    ];
  };
}
