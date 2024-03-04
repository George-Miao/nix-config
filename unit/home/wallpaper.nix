{pkgs, ...}: let
  fetched = pkgs.fetchFromGitHub {
    owner = "linuxdotexe";
    repo = "nordic-wallpapers";
    rev = "657558d9031a256445d96d553e9c50eb49c80cfb";
    hash = "sha256-97CT/ZCWRg6D0NxohGAFdVvhtxI2aOpHB1ArU5C4Y8Q=";
  };
in {
  home.file.wallpapers = {
    enable = true;
    target = ".wallpaper";
    source = fetched + "/wallpapers";
  };

  programs.feh.enable = true;

  systemd.user = {
    services.update-wallpaper = {
      Unit = {
        Description = "Update wallpaper";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --bg-fill --randomize %h/.wallpaper";
      };

      Install.WantedBy = ["default.target"];
    };

    timers.update-wallpaper = {
      Unit = {
        Description = "Update wallpaper every 30 minutes";
      };

      Timer = {
        OnActiveSec = 0;
        OnStartupSec = 0;
        OnUnitActiveSec = "30m";
        Persistent = true;
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
