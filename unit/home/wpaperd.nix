{
  nixosConfig,
  flake,
  lib,
  pkgs,
  ...
}: let
  home = nixosConfig.users.users.${flake.config.user}.home;
in {
  imports = [
    ./pop-wallpaper.nix
  ];

  programs.wpaperd = {
    enable = true;
    settings = {
      any = {
        path = "${home}/Wallpapers";
        duration = "1hr";
      };
    };
  };
}
