{pkgs, ...}: {
  imports = [./pop-wallpaper.nix];

  programs.feh.enable = true;

  systemd.user = {
    services.update-wallpaper = {
      Unit = {
        Description = "Update wallpaper";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --bg-fill --randomize %h/Wallpapers";
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
