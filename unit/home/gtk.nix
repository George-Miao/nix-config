{
  pkgs,
  ...
}:
{
  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };

    gtk2.extraConfig = "gtk-im-module = \"fcitx\"";

    gtk3.extraConfig = {
      gtk-im-module = "fcitx";
    };

    gtk4 = {
      extraConfig = {
        gtk-im-module = "fcitx";
      };
    };
  };

  home.packages = [ pkgs.dconf ];
}
