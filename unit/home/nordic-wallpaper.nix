{
  flake,
  pkgs,
  ...
}: {
  home.file.wallpapers = {
    enable = true;
    target = "Wallpapers";
    source = (flake.self.tools.generate pkgs).nordic-wallpaper.src + "/wallpapers";
  };
}
