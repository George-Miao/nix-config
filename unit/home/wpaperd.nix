{
  nixosConfig,
  lib,
  ...
}:
let
  home = nixosConfig.users.users.pop.home;
in
{
  imports = [
    ./pop-wallpaper.nix
  ];

  services.wpaperd = {
    enable = true;

    settings = {
      any = {
        path = "${home}/Wallpapers";
        duration = "1hr";
      };
    };
  };

  systemd.user.services.wpaperd.Service.Environment =
    lib.optional (builtins.elem "nvidia" nixosConfig.services.xserver.videoDrivers) "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
}
