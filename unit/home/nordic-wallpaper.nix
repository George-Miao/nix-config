{
  tools,
  pkgs,
  ...
}:
{
  home.file.nordic-wallpaper = {
    enable = true;
    target = "Wallpapers";
    recursive = true;
    source = (tools.generate pkgs).nordic-wallpaper.src + "/wallpapers";
  };
}
