{config, ...}: {
  xdg.portal.xdgOpenUsePortal = true;

  home-manager.users.${config.user}.xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/x-sony-arw" = "org.gnome.eog.desktop";
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
    };
    associations = {
      added = {
        "image/x-sony-arw" = "org.gnome.eog.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
      };
    };
  };
}
