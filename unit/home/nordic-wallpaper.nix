{flake, ...}: {
  home.file.wallpapers = {
    enable = true;
    target = "Wallpapers";
    source = flake.self.generated.nordic-wallpaper.src + "/wallpapers";
  };
}
