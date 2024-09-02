{...}: {
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/x-sony-arw" = "org.gnome.eog.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      };
      associations = {
        added = {
          "image/x-sony-arw" = "org.gnome.eog.desktop";
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        };
      };
    };
  };
}
