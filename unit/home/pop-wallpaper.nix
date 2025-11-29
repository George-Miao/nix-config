{
  pkgs,
  ...
}:
{
  home.file.pop-wallpapers = {
    enable = true;
    target = "Wallpapers";
    recursive = true;
    source = pkgs.pop-wallpaper.src + "/wallpaper";
  };
}
