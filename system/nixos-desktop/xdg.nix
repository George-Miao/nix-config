{config, ...}: let
  map = {
    "image/x-sony-arw" = "org.gnome.eog.desktop";
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
    "application/pdf" = "org.gnome.Evince.desktop";
    "x-scheme-handler/http" = "zen-twilight.desktop";
    "x-scheme-handler/https" = "zen-twilight.desktop";
    "x-scheme-handler/chrome" = "zen-twilight.desktop";
    "text/html" = "zen-twilight.desktop";
    "application/x-extension-htm" = "zen-twilight.desktop";
    "application/x-extension-html" = "zen-twilight.desktop";
    "application/x-extension-shtml" = "zen-twilight.desktop";
    "application/xhtml+xml" = "zen-twilight.desktop";
    "application/x-extension-xhtml" = "zen-twilight.desktop";
    "application/x-extension-xht " = "zen-twilight.desktop";
  };
in {
  home-manager.users.${config.user}.xdg.mimeApps = {
    enable = true;
    defaultApplications = map;
    associations = {
      added = map;
    };
  };
}
