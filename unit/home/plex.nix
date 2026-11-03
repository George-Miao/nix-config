{
  nixosConfig,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.plex-desktop.override {
      extraEnv = {
        WAYLAND_DISPLAY = "";
      }
      // lib.optionalAttrs (builtins.elem "nvidia" nixosConfig.services.xserver.videoDrivers) {
        QSG_RENDER_LOOP = "basic";
        QTWEBENGINE_CHROMIUM_FLAGS = "--disable-gpu --disable-gpu-compositing";
      };
    })
  ];
}
