{
  flake,
  pkgs,
  ...
}: {
  home.file.pop-wallpapers = {
    enable = true;
    target = "Wallpapers";
    recursive = true;
    source = (flake.self.tools.generate pkgs).pop-wallpaper.src + "/wallpaper";
  };
}
