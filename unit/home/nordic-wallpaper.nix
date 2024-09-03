{
  flake,
  pkgs,
  ...
}: {
  home.file.nordic-wallpaper = {
    enable = true;
    target = "Wallpapers";
    recursive = true;
    source = (flake.self.tools.generate pkgs).nordic-wallpaper.src + "/wallpapers";
  };
}
