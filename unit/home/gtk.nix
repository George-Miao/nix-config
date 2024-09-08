{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        size = "compact";
        tweaks = ["rimless" "normal"];
        variant = "macchiato";
      };
    };

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

    gtk4.extraConfig = {
      gtk-im-module = "fcitx";
    };
  };

  home.packages = [pkgs.dconf];

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };
}
