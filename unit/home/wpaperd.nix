{
  nixosConfig,
  pkgs,
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

    package = pkgs.wpaperd.overrideAttrs (
      final: prev: {
        cargoHash = "sha256-Vz5x9V+q5OwRR/GdiM/kEEfENSQ+KyN3DKM35NHuzAk=";
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit (final) src;
          name = "${final.pname}-${final.version}";
          hash = final.cargoHash;
        };
        src = pkgs.fetchgit {
          "url" = "https://github.com/LukeCarrier/wpaperd";
          "rev" = "449750a2d24ab3d7895da7d0fd2923f2c8a3a913";
          "hash" = "sha256-TnGSGegU+Ge8uh13hUFZ+OTbPtEja+tBSe+eyxEElXc=";
        };
      }
    );

    settings = {
      any = {
        path = "${home}/Wallpapers";
        duration = "1hr";
      };
    };
  };

  # systemd.user.services.wpaperd.Service.Environment = [
  #   "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json"
  # ];
}
