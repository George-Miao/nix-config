{
  nixosConfig,
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
}
