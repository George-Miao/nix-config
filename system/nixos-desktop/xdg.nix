{config, ...}: let
  map = {
    "image/x-sony-arw" = "org.gnome.eog.desktop";
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
    "application/pdf" = "org.gnome.Evince.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht " = "firefox.desktop";
  };
in {
  xdg.portal.xdgOpenUsePortal = true;

  home-manager.users.${config.user}.xdg.mimeApps = {
    enable = true;
    defaultApplications = map;
    associations = {
      added = map;
    };
  };
}
