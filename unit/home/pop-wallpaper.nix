{
  tools,
  pkgs,
  ...
}: {
  home.file.pop-wallpapers = {
    enable = true;
    target = "Wallpapers";
    recursive = true;
    source = (tools.generate pkgs).pop-wallpaper.src + "/wallpaper";
  };
}
