{
  pkgs,
  ...
}:
{
  home.file.nordic-wallpaper = {
    enable = true;
    target = "Wallpapers";
    recursive = true;
    source = pkgs.nordic-wallpaper.src + "/wallpapers";
  };
}
